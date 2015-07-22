'       **********************************************************************************************
'       *                                                                                            *
'       *       PNut Booter                                                                          *
'       *                                                                                            *
'       *       Version 0.1   12/10/2004                                                             *
'       *                                                                                            *
'       *       Copyright 2004, 2014 Parallax Inc.                                                   *
'       *                                                                                            *
'       *       This file is part of the hardware description for the Propeller 1 Design.            *
'       *                                                                                            *
'       *       The Propeller 1 Design is free software: you can redistribute it and/or modify       *
'       *       it under the terms of the GNU General Public License as published by the             *
'       *       Free Software Foundation, either version 3 of the License, or (at your option)       *
'       *       any later version.                                                                   *
'       *                                                                                            *
'       *       The Propeller 1 Design is distributed in the hope that it will be useful,            *
'       *       but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY       *
'       *       or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for         *
'       *       more details.                                                                        *
'       *                                                                                            *
'       *       You should have received a copy of the GNU General Public License along with         *
'       *       the Propeller 1 Design.  If not, see <http://www.gnu.org/licenses/>.                 *
'       *                                                                                            *
'       **********************************************************************************************
'
'
' Entry
'
DAT                     org

                        test    mask_rx,ina     wc      'if rx high, check for host
        if_nc           jmp     #boot                   'else, boot from eeprom

                        call    #rx_bit                 'measure rx calibration pulses ($F9)
                        mov     threshold,delta         'and calculate threshold
                        call    #rx_bit                 '(any timeout results in eeprom boot)
                        add     threshold,delta
                        shr     threshold,#1

                        mov     count,#250              'ready to receive/verify 250 lfsr bits
:lfsrin                 call    #rx_bit                 'receive bit ($FE/$FF) into c
                        muxc    lfsr,#$100              'compare to lfsr lsb
                        test    lfsr,#$101      wc
        if_c            jmp     #boot                   'if mismatch, boot from eeprom
                        test    lfsr,#$B2       wc      'advance lfsr
                        rcl     lfsr,#1
                        djnz    count,#:lfsrin

                        or      outa,mask_tx            'host present, make tx high output
                        or      dira,mask_tx

                        mov     count,#250              'ready to transmit 250 lfsr bits
:lfsrout                test    lfsr,#$01       wz      'send lfsr bit ($FE/$FF)
                        call    #tx_bit
                        test    lfsr,#$B2       wc      'advance lfsr
                        rcl     lfsr,#1
                        djnz    count,#:lfsrout

                        rdbyte  bits,hFFF9FFFF          'get version byte at $FFFF
                        mov     count,#8                'send version byte
:version                test    bits,#$01       wz
                        call    #tx_bit
                        shr     bits,#1
                        djnz    count,#:version

                        call    #rx_long                'receive command
                        mov     command,rxdata

                        tjz     command,#shutdown       'if command 0, shutdown
                        cmp     command,#4      wc      'if command 4+, shutdown
        if_nc           jmp     #shutdown

                        call    #rx_long                'get long count
                        mov     count,rxdata

                        mov     address,#0              'get longs into ram
:longs                  call    #rx_long
                        wrlong  rxdata,address
                        add     address,#4
                        djnz    count,#:longs

                        mov     count,h8000             'zero remainder of ram
                        sub     count,address
                        shr     count,#2        wz
:zero   if_nz           wrlong  zero,address
        if_nz           add     address,#4
        if_nz           djnz    count,#:zero            '(count=0, address=$8000)

                        rdword  bits,#$0004+6           'get dbase address
                        sub     bits,#4                 'set pcurr to $FFF9
                        wrlong  hFFF9FFFF,bits
                        sub     bits,#4                 'set pbase flags
                        wrlong  hFFF9FFFF,bits

                        mov     bits,#0                 'compute ram checksum
:checksum               rdbyte  rxdata,count
                        add     bits,rxdata
                        add     count,#1
                        djnz    address,#:checksum
                        test    bits,#$FF       wz      'z=1 if checksum okay

                        call    #tx_bit_align           'send checksum okay/error

        if_nz           jmp     #shutdown               'if checksum error, shutdown

                        djnz    command,#program        'if command 2-3, program eeprom
                        jmp     #launch                 'else command 1, launch
'
'
' Program and verify eeprom from ram
'
program                 mov     smode,#1                'set mode in case error

                        mov     address,#0              'reset address
:page                   call    #ee_write               'send program command
                        mov     count,#$40              'page-program $40 bytes
:byte                   rdbyte  eedata,address          'get ram byte
                        call    #ee_transmit            'send ram byte
        if_c            jmp     #shutdown               'if no ack, shutdown
                        add     address,#1              'inc address
                        djnz    count,#:byte            'loop until page sent
                        call    #ee_stop                'initiate page-program cycle
                        cmp     address,h8000   wz      'check for address $8000
        if_nz           jmp     #:page                  'loop until done (z=1 after)

                        call    #tx_bit_align           'program done, send okay (z=1)

                        call    #ee_read                'send read command
:verify                 call    #ee_receive             'get eeprom byte
                        rdbyte  bits,address            'get ram byte
                        cmp     bits,eedata     wz      'compare bytes
        if_nz           jmp     #shutdown               'if verify error, shutdown (sends error)
                        add     address,#1              'inc address
                        djnz    count,#:verify          'loop until done
                        call    #ee_stop                'end read (z=1 from before)

                        call    #tx_bit_align           'verify done, send okay (z=1)

                        mov     smode,#0                'clear mode in case error

                        djnz    command,#launch         'if command 3, launch
                        jmp     #shutdown               'else command 2, shutdown
'
'
' Load ram from eeprom and launch
'
boot                    mov     smode,#0                'clear mode in case error

                        call    #ee_read                'send read command
:loop                   call    #ee_receive             'get eeprom byte
                        wrbyte  eedata,address          'write to ram
                        add     address,#1              'inc address
                        djnz    count,#:loop            'loop until done
                        call    #ee_stop                'end read (followed by launch)
'
'
' Launch program in ram
'
launch                  rdword  address,#$0004+2        'if pbase address invalid, shutdown
                        cmp     address,#$0010  wz
        if_nz           jmp     #shutdown

                        rdbyte  address,#$0004          'if xtal/pll enabled, start up now
                        and     address,#$F8            '..while remaining in rcfast mode
                        clkset  address

:delay                  djnz    time_xtal,#:delay       'allow 20ms @20MHz for xtal/pll to settle

                        rdbyte  address,#$0004          'switch to selected clock
                        clkset  address

                        coginit interpreter             'reboot cog with interpreter
'
'
' Shutdown
'
shutdown                mov     ee_jmp,#0               'deselect eeprom (replace jmp with nop)
:call                   call    #ee_stop                '(always returns)

                        cmp     smode,#0        wz      'if serial mode, send error (z=0)
        if_nz           mov     smode,#0                '(only do once)
        if_nz           mov     :call,#0                '(replace call with nop)
        if_nz           call    #tx_bit_align           '(may return to shutdown, no problem)

                        mov     dira,#0                 'cancel any outputs

                        mov     smode,#$02              'stop clock
                        clkset  smode                   '(suspend until reset)
'
'
'**************************************
'* I2C routines for 24x256/512 EEPROM *
'* assumes fastest RC timing - 20MHz  *
'*   SCL low time  =  8 inst, >1.6us  *
'*   SCL high time =  4 inst, >0.8us  *
'*   SCL period    = 12 inst, >2.4us  *
'**************************************
'
'
' Begin eeprom read
'
ee_read                 mov     address,#0              'reset address

                        call    #ee_write               'begin write (sets address)

                        mov     eedata,#$A1             'send read command
                        call    #ee_start
        if_c            jmp     #shutdown               'if no ack, shutdown

                        mov     count,h8000             'set count to $8000

ee_read_ret             ret
'
'
' Begin eeprom write
'
ee_write                call    #ee_wait                'wait for ack and begin write

                        mov     eedata,address          'send high address
                        shr     eedata,#8
                        call    #ee_transmit
        if_c            jmp     #shutdown               'if no ack, shutdown

                        mov     eedata,address          'send low address
                        call    #ee_transmit
        if_c            jmp     #shutdown               'if no ack, shutdown

ee_write_ret            ret
'
'
' Wait for eeprom ack
'
ee_wait                 mov     count,#400              '       400 attempts > 10ms @20MHz
:loop                   mov     eedata,#$A0             '1      send write command
                        call    #ee_start               '132+
        if_c            djnz    count,#:loop            '1      if no ack, loop until done

        if_c            jmp     #shutdown               '       if no ack, shutdown

ee_wait_ret             ret
'
'
' Start + transmit
'
ee_start                mov     bits,#9                 '1      ready 9 start attempts
:loop                   andn    outa,mask_scl           '1(!)   ready scl low
                        or      dira,mask_scl           '1!     scl low
                        nop                             '1
                        andn    dira,mask_sda           '1!     sda float
                        call    #delay5                 '5
                        or      outa,mask_scl           '1!     scl high
                        nop                             '1
                        test    mask_sda,ina    wc      'h?h    sample sda
        if_nc           djnz    bits,#:loop             '1,2    if sda not high, loop until done

        if_nc           jmp     #shutdown               '1      if sda still not high, shutdown

                        or      dira,mask_sda           '1!     sda low
'
'
' Transmit/receive
'
ee_transmit             shl     eedata,#1               '1      ready to transmit byte and receive ack
                        or      eedata,#%00000000_1     '1
                        jmp     #ee_tr                  '1

ee_receive              mov     eedata,#%11111111_0     '1      ready to receive byte and transmit ack

ee_tr                   mov     bits,#9                 '1      transmit/receive byte and ack
:loop                   test    eedata,#$100    wz      '1      get next sda output state
                        andn    outa,mask_scl           '1!     scl low
                        rcl     eedata,#1               '1      shift in prior sda input state
                        muxz    dira,mask_sda           '1!     sda low/float
                        call    #delay4                 '4
                        test    mask_sda,ina    wc      'h?h    sample sda
                        or      outa,mask_scl           '1!     scl high
                        nop                             '1
                        djnz    bits,#:loop             '1,2    if another bit, loop

                        and     eedata,#$FF             '1      isolate byte received
ee_receive_ret
ee_transmit_ret
ee_start_ret            ret                             '1      nc=ack
'
'
' Stop
'
ee_stop                 mov     bits,#9                 '1      ready 9 stop attempts
:loop                   andn    outa,mask_scl           '1!     scl low
                        nop                             '1
                        or      dira,mask_sda           '1!     sda low
                        call    #delay5                 '5
                        or      outa,mask_scl           '1!     scl high
                        call    #delay3                 '3
                        andn    dira,mask_sda           '1!     sda float
                        call    #delay4                 '4
                        test    mask_sda,ina    wc      'h?h    sample sda
        if_nc           djnz    bits,#:loop             '1,2    if sda not high, loop until done

ee_jmp  if_nc           jmp     #shutdown               '1      if sda still not high, shutdown

ee_stop_ret             ret                             '1
'
'
' Cycle delays
'
delay5                  nop                             '1
delay4                  nop                             '1
delay3                  nop                             '1
delay2
delay2_ret
delay3_ret
delay4_ret
delay5_ret              ret                             '1
'
'
'*******************
'* Serial routines *
'*******************
'
'
' Transmit bit (nz)
' conveys incoming $F9 on rx to $FE/$FF on tx
'
tx_bit_align            mov     time,time_load          'reset time limit

:align                  call    #rx_bit                 'align to next $F9
        if_c            jmp     #:align

tx_bit                  mov     time,time_load          'reset time limit

:high                   test    mask_rx,ina     wc      'wait while high
        if_c            djnz    time,#:high
        if_c            jmp     #shutdown               'if timeout, shutdown

                        andn    outa,mask_tx            'tx low

:low                    test    mask_rx,ina     wc      'wait while low
        if_nc           djnz    time,#:low
        if_nc           jmp     #shutdown               'if timeout, shutdown

                        muxnz   outa,mask_tx            'tx low/high

:high2                  test    mask_rx,ina     wc      'wait while high
        if_c            djnz    time,#:high2
        if_c            jmp     #shutdown               'if timeout, shutdown

                        or      outa,mask_tx            'tx high

:low2                   test    mask_rx,ina     wc      'wait while low
        if_nc           djnz    time,#:low2
        if_nc           jmp     #shutdown               'if timeout, shutdown

tx_bit_ret
tx_bit_align_ret        ret
'
'
' Receive long
'
rx_long                 mov     time,time_load          'reset time limit

                        mov     bits,#32                'ready for 32 bits
:loop                   call    #rx_bit                 'input bit
                        rcr     rxdata,#1               'shift into long
                        djnz    bits,#:loop             'loop until done

rx_long_ret             ret
'
'
' Receive bit (c)
'
rx_bit                  test    mask_rx,ina     wc      'wait while rx high
        if_c            djnz    time,#rx_bit
        if_c            jmp     #boot                   'if timeout, boot from eeprom

                        mov     delta,time              'time while rx low

:loop                   test    mask_rx,ina     wc      'h?h    2 instructions/loop
        if_nc           djnz    time,#:loop             '1      400ns @20MHz...1us @8MHz
        if_nc           jmp     #boot                   'if timeout, boot from eeprom

                        sub     delta,time              'delta = rx low time in loops
                        cmp     delta,threshold wc      'resolve bit into c

rx_bit_ret              ret
'
'
' Constants
'
mask_rx                 long    $80000000
mask_tx                 long    $40000000
mask_sda                long    $20000000
mask_scl                long    $10000000
time                    long    150 * 20000 / 4 / 2     '150ms (@20MHz, 2 inst/loop)
time_load               long    100 * 20000 / 4 / 2     '100ms (@20MHz, 2 inst/loop)
time_xtal               long    20 * 20000 / 4 / 1      '20ms (@20MHz, 1 inst/loop)
lfsr                    long    "P"
zero                    long    0
smode                   long    0
hFFF9FFFF               long    $FFF9FFFF
h8000                   long    $8000
interpreter             long    $0001 << 18 + $3C01 << 4 + %0000
'
'
' Variables
'
command                 res     1
address                 res     1
count                   res     1
bits                    res     1
eedata                  res     1
rxdata                  res     1
delta                   res     1
threshold               res     1
