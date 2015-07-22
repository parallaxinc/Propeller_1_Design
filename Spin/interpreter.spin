'       **********************************************************************************************
'       *                                                                                            *
'       *       PNut Interpreter                                                                     *
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
' set   byte            description                     pops    push    extra bytes
' ----------------------------------------------------------------------------------------------
' 0     000000tp        drop anchor                                     (t=try, !p=push)
'
' 1     00000100        jmp                                             +1..2 address
'       00000101        call sub                                        +1 sub
'       00000110        call obj.sub                                    +2 obj+sub
'       00000111        call obj[].sub                  1               +2 obj+sub
'
' 2     00001000        tjz                             1       0/1     +1..2 address
'       00001001        djnz                            1       0/1     +1..2 address
'       00001010        jz                              1               +1..2 address
'       00001011        jnz                             1               +1..2 address
'
' 3     00001100        casedone                        2               +1..2 address
'       00001101        value case                      1               +1..2 address
'       00001110        range case                      2               +1..2 address
'       00001111        lookdone                        3       1
'
' 4     00010000        value lookup                    1
'       00010001        value lookdown                  1
'       00010010        range lookup                    2
'       00010011        range lookdown                  2
'
' 5     00010100        pop                             1+
'       00010101        run
'       00010110        STRSIZE(string)                 1       1
'       00010111        STRCOMP(stringa,stringb)        2       1
'
' 6     00011000        BYTEFILL(start,value,count)     3
'       00011001        WORDFILL(start,value,count)     3
'       00011010        LONGFILL(start,value,count)     3
'       00011011        WAITPEQ(data,mask,port)         3
'
' 7     00011100        BYTEMOVE(to,from,count)         3
'       00011101        WORDMOVE(to,from,count)         3
'       00011110        LONGMOVE(to,from,count)         3
'       00011111        WAITPNE(data,mask,port)         3
'
' 8     00100000        CLKSET(mode,freq)               2
'       00100001        COGSTOP(id)                     1
'       00100010        LOCKRET(id)                     1
'       00100011        WAITCNT(count)                  1
'
' 9     001001oo        SPR[nibble] op                  1                               +1 if assign
'       00100111        WAITVID(colors,pixels)          2
'
' A/B   00101p00        COGINIT(id,adr,ptr)             3       1/0     (!p=push)
'       00101p01        LOCKNEW                                 1/0     (!p=push)
'       00101p10        LOCKSET(id)                     1       1/0     (!p=push)
'       00101p11        LOCKCLR(id)                     1       1/0     (!p=push)
'
' C     00110000        ABORT
'       00110001        ABORT value                     1
'       00110010        RETURN
'       00110011        RETURN value                    1
'
' D     001101cc        constant -1..1                          1
'       00110111        constant mask                           1       +1 maskdata
'
' E     001110bb        constant 1..4 bytes                     1       +1..4 constant
'
' F     00111100        <unused>
'       00111101        register[bit] op                1               +1 reg+op,      +1 if assign
'       00111110        register[bit..bit] op           2               +1 reg+op,      +1 if assign
'       00111111        register op                                     +1 reg+op,      +1 if assign
'
'       01bxxxoo        variable op                                                     +1 if assign
'
'       1ssibboo        memory op                                       +1..2 if base,  +1 if assign
'
'       111xxxxx        math op
'
'
' variable operators
'
' mem   ss      i       bb      oo
'       -------------------------------
'   00| byte    none    pop     read
'   01| word    pop     pbase   write
'   10| long            vbase   assign
'   11|                 dbase   address
'
' var   b       xxx     oo
'       -----------------------
'   00| vbase   offset  read
'   01| dbase           write
'   10|                 assign
'   11|                 address
'
' reg   oo      xxxxx   (extra byte)
'       -------------
'   00| read    reg
'   01| write
'   10| assign
'
' op    tt              oo
'       -----------------------
'   00| memory          read
'   01| register        write
'   10| (register)      assign
'   11| register[]      address
'
'
' assignment operators (p=push, ss=size: 00=bit, 01=byte, 10=word, 11=long)
'
'       p000000-                write
'       -0000s1-                repeat-var loop (s = pop step) +1..2 address
'       p00010--        ?var    random forward (long)
'       p00011--        var?    random reverse (long)
'       p00100--        ~var    sign-extend byte
'       p00101--        ~~var   sign-extend word
'       p00110--        var~    post-clear
'       p00111--        var~~   post-set
'       p0100ss-        ++var   pre-inc (mask by size)
'       p0101ss-        var++   post-inc (mask by size)
'       p0110ss-        --var   pre-dec (mask by size)
'       p0111ss-        var--   post-dec (mask by size)
'       p1sxxxxx                math operator (!s = swap binary args)
'
'
' initial parameters
'
'       par     word
'       -----------------
'       +2      pbase
'       +4      vbase
'       +6      dbase
'       +8      pcurr
'       +A      dcurr
'
' Entry
'
DAT                     org

                        mov     x,#$1F0-pbase           'entry, load initial parameters
                        mov     y,par
:loop                   add     y,#2
:par                    rdword  pbase,y
                        add     :par,#$100              'inc d lsb
                        add     :par,#$100
                        djnz    x,#:loop

                        cogid   id                      'set id
'
'
' Main loop
'
loop                    mov     x,#0                    'reset x

                        rdbyte  op,pcurr                'get opcode
                        add     pcurr,#1

                        cmp     op,#$40         wc      'upper?
        if_nc           jmp     #upper

                        mov     t1,op                   'jump to handler
                        ror     t1,#4
                        add     t1,#jumps
                        movs    :jump,t1
                        rol     t1,#2
                        shl     t1,#3
:jump                   mov     t2,jumps
                        shr     t2,t1
                        and     t2,#$FF
                        movs    getret,t2

getflags                test    op,#%01         wz
getc                    test    op,#%10         wc

getret                  ret


jumps                   byte    j0,j1,j2,j3
                        byte    j4,j5,j6,j7
                        byte    j8,j9,jA,jB
                        byte    jC,jD,jE,jF
'
'
' drop anchor
'
j0                      or      op,pbase                'add pbase into flags

                        wrword  op,dcurr                'push return pbase (and flags)
                        add     dcurr,#2

                        wrword  vbase,dcurr             'push return vbase
                        add     dcurr,#2

                        wrword  dbase,dcurr             'push return dbase
                        add     dcurr,#2

                        wrword  dcall,dcurr             'push dcall (later used for pcurr)
                        mov     dcall,dcurr             'set new dcall
                        add     dcurr,#2

                        jmp     #push                   'init 'result' to 0
'
'
' jmp
' call sub
' call obj.sub
' call obj[].sub
'
callobj                 add     pbase,x                 'set relative obj bases
                        add     vbase,y         wc      '(c=0, z=0 still)

j1      if_nc_and_z     jmp     #jmpadr                 'entry, jmp?

        if_c_and_nz     call    #popx                   'pop index

                        rdbyte  y,pcurr                 'get obj/sub byte
                        add     pcurr,#1

        if_c_and_nz     add     y,x                     'add any obj index

                        shl     y,#2                    'lookup words from table
                        add     y,pbase
                        rdlong  y,y

                        mov     x,y                     'get low word
                        shr     y,#16                   'get high word

        if_c            jmp     #callobj        wz      'obj[].sub? (z=0)

                        mov     dbase,dcall             'get new dcall
                        rdword  dcall,dcall             'set old dcall
                        wrword  pcurr,dbase             'set return pcurr
                        add     dbase,#2                'set call dbase

                        add     dcurr,y                 'set call dcurr

spcurr  if_nc           mov     pcurr,pbase             'set call pcurr (c=0)
        if_nc           add     pcurr,x

                        jmp     #loop
'
'
' tjz - push if nz
' djnz - push if nz
' jz
' jnz
'
j2                      call    #popx                   'pop count/boolean

jmpadr                  jmpret  getret,#getadrs         'get sign-extended address

        if_nc_and_nz    sub     x,#1                    'if djnz, decrement

                        cmp     x,#1            wc      'determine branch

apcurr  if_c_eq_z       add     pcurr,op2               'branch?

                        muxc    op,#%00001001   wz      'if tjz/djnz and not 0, push, else loop

pushz   if_z            jmp     #push                   'if z, push result
        if_nz           jmp     #loop                   'if nz, loop
'
'
' casedone
' value case
' range case
' lookdone
'
j3      if_nc_and_z     jmp     #cased                  'if casedone, pop target+address, jump

        if_c_and_nz     sub     dcurr,#12               'if lookdone, pop target+address+index
        if_c_and_nz     jmp     #push                   '..and push zero

                        jmpret  getret,#getadrs wz      'case, get sign-extended address (c=same, z=0)
'
'
' value lookup
' value lookdown
' range lookup
' range lookdown
'
j4      if_nc           call    #popyx                  'if value, pop value and target
        if_nc           mov     a,y                     'x = target, y..a = range

        if_c            call    #popayx                 'if range, pop range values and target

                        sub     dcurr,#8                'pop index into t1 (underneath address)
                        rdlong  t1,dcurr

                        cmps    a,y             wc      'reverse range?

                        negc    t2,x                    'set t2 for in-range..
        if_nc           sumz    t2,t1                   'forward lookup:        -t1 + x + y
        if_c            add     t2,t1                   'forward lookdown:       t1 + x - y
        if_nc           sumnz   t2,y                    'reverse lookup:         t1 - x + y
        if_c            add     t2,y                    'reverse lookdown:       t1 - x + y

                        call    #range                  'check if x in range y..a according to c

        if_z            cmp     x,t1            wc      'if lookup, c=0 if index within range
                        add     t1,a                    'on first compare, t1 = index
                        sub     t1,y                    'on second compare, t1 = index+a-y
        if_z_and_nc     cmp     t1,x            wc

        if_nc           mov     t1,t2                   'if in range, t1 = t2
        if_c            add     t1,#1                   'if out of range, t1 = index+a-y+1

                        test    op,#%100        wz      'look or case?

        if_z            wrlong  t1,dcurr                'if look, update index

                        add     dcurr,#12               'unpop index+address+target

cased   if_z_and_nc     call    #popyx                  'if look true or casedone, pop target and address
        if_z            jmp     #spcurr                 'if look true or casedone, branch or loop

                        jmp     #apcurr                 'case, branch if true
'
'
' pop
' run
' STRSIZE(string)
' STRCOMP(stringa,stringb)
'
j5      if_z            call    #popx                   'if pop/strsize, pop count/string
        if_nc_and_z     sub     dcurr,x                 'if pop, subtract count from dcurr

        if_nc_and_nz    mov     lsb,pcurr               'if run, save pcurr and set to $FFFC
        if_nc_and_nz    mov     pcurr,maskpar

        if_nc           jmp     #loop                   'if pop/run, loop


        if_nz           call    #popyx                  'if strcomp, pop stringa/stringb
                        mov     a,x                     'stringa/string in a, stringb in y
                        neg     x,#1                    'init !count in x

:loop                   rdbyte  t1,a                    'measure/compare string(s)
                        add     a,#1
        if_z            tjz     t1,#notx                'if strsize and 0, return count (c=1)
        if_nz           rdbyte  t2,y
        if_nz           add     y,#1
        if_nz           xor     t1,t2
        if_nz           tjnz    t1,#mtst2               'if strcomp and mismatch, return false (z=0)
        if_nz           tjz     t2,#mtst2       wz      'if strcomp and 0, return true (z=1)
                        djnz    x,#:loop                'loop - never falls through
'
'
' BYTEFILL(start,value,count)
' WORDFILL(start,value,count)
' LONGFILL(start,value,count)
'
' BYTEMOVE(to,from,count)
' WORDMOVE(to,from,count)
' LONGMOVE(to,from,count)
'
j6
j7                      call    #popayx                 'fill/move/wait, pop parameters
        if_c_and_nz     jmp     #waitpin                'waitpeq/waitpne?

                        tjz     a,#loop                 'if count=0, done

                        test    op,#%100        wc,wz   'fill or move?
                        and     op,#%11                 'isolate size bits
        if_z            mov     t1,y                    'if fill, set value
                        
        if_nz           cmp     y,x             wc      'if upward move, modify pointers
        if_nz_and_c     mov     t2,a
        if_nz_and_c     sub     t2,#1
        if_nz_and_c     shl     t2,op
        if_nz_and_c     add     y,t2
        if_nz_and_c     add     x,t2

                        negc    t2,#1                   'set inc/dec
                        shl     t2,op

                        shl     op,#3                   'set word size
                        movi    fill,op
                        or      op,#%000000_001
                        movi    move,op

maskword                long    $0000FFFF               'nop/constant

move    if_nz           rdlong  t1,y                    'move/fill loop
        if_nz           add     y,t2
fill                    wrlong  t1,x
                        add     x,t2
                        djnz    a,#move

                        jmp     #loop
'
'
' WAITPEQ(data,mask,port)
' WAITPNE(data,mask,port)
'
waitpin                 test    a,#1            wc
                        test    op,#%100        wz

        if_z            waitpeq x,y                     'waitpeq
        if_nz           waitpne x,y                     'waitpne

                        jmp     #loop
'
'
' CLKSET(mode,freq)
' COGSTOP(id)
' LOCKRET(id)
' WAITCNT(count)
'
j8      if_nc_and_z     call    #popyx                  'clkset
        if_nc_and_z     clkset  x
        if_nc_and_z     wrlong  y,#$0000
        if_nc_and_z     wrbyte  x,#$0004

        if_c_or_nz      call    #popx                   'pop parameter
        if_nc_and_nz    cogstop x                       'cogstop
        if_c_and_z      lockret x                       'lockret
        if_c_and_nz     waitcnt x,#0                    'waitcnt

                        jmp     #loop
'
'
' SPR[nibble]
' WAITVID(colors,pixels)
'
j9
        if_c_and_nz     call    #popyx                  'waitvid
        if_c_and_nz     waitvid x,y
        if_c_and_nz     jmp     #loop

                        call    #popx                   'spr
                        or      x,#$10
                        test    x,#$10          wc,wz   'c=1, z=0
                        jmp     #regindex
'
'
' COGINIT(id,ptr,par)
' LOCKNEW
' LOCKSET(id)
' LOCKCLR(id)
'
jA
jB      if_c            jmp     #:lock                  'lockclr/lockset?

        if_z            call    #popayx                 'coginit, pop parameters
        if_z            and     a,maskpar               'assemble fields
        if_z            shl     a,#16
        if_z            and     y,maskpar
        if_z            shl     y,#2
        if_z            or      y,a
        if_z            max     x,#8
        if_z            or      x,y
        if_z            coginit x               wc,wr

        if_nz           locknew x               wc      'locknew

        if_c            neg     x,#1                    '-1 if c, else 0..7
                        jmp     #:push


:lock                   call    #popx                   'lockclr/lockset, pop id

        if_z            lockset x               wc      'clr/set lock
        if_nz           lockclr x               wc

                        muxc    x,masklong              '-1 if c, else 0


:push                   test    op,#%100        wz      'push result?
                        jmp     #pushz
'
'
' ABORT
' ABORT value
' RETURN
' RETURN value
'
jC      if_z            rdlong  x,dbase                 'if no value, get 'result'
        if_nz           call    #popx                   'if value, pop result

:loop                   mov     dcurr,dbase             'restore dcurr

                        sub     dcurr,#2                'pop pcurr
                        rdword  pcurr,dcurr

                        sub     dcurr,#2                'pop dbase
                        rdword  dbase,dcurr

                        sub     dcurr,#2                'pop vbase
                        rdword  vbase,dcurr

                        sub     dcurr,#2                'pop pbase (and flags)
                        rdword  pbase,dcurr

        if_nc           test    pbase,#%10      wc      'if abort and !try, return again
        if_nc           jmp     #:loop

                        test    pbase,#%01      wz      'get push flag

                        and     pbase,maskpar           'trim pbase

                        jmp     #pushz                  'push 'result'?
'
'
' constant -1..1
' constant mask
'
jD                      mov     x,op                    'get -1..2 into x
                        sub     x,#%00110101

        if_nc_or_z      jmp     #push                   'if constant -1..1, push


                        rdbyte  y,pcurr                 'constant mask, get data byte
                        add     pcurr,#1

                        rol     x,y                     'decode, x = 2 before

                        test    y,#%001_00000   wc      'decrement?
        if_c            sub     x,#1

                        test    y,#%010_00000   wc      'not?
notx    if_c            xor     x,masklong

                        jmp     #push
'
'
' constant 1..4 bytes
'
jE                      sub     op,#%00111000-1

:loop                   rdbyte  a,pcurr
                        add     pcurr,#1
                        shl     x,#8
                        or      x,a
                        djnz    op,#:loop

                        jmp     #push
'
'
' <unused>
' register[bit] op
' register[bit..bit] op
' register op
'
jF                      rdbyte  x,pcurr                 'register, get reg+op byte
                        add     pcurr,#1

                        mov     op,x                    'justify op (sets type to register)
                        shr     op,#5

regindex                or      x,#$1E0                 'install register
                        movs    writef,x
                        movd    writer,x
                        movs    readr,x

        if_c_and_nz     jmp     #mrop                   'register?

        if_nc           call    #popx                   'register bit?
        if_nc           mov     y,x

        if_c            call    #popyx                  'register range?

                        and     x,#$1F                  'trim bit/range
                        and     y,#$1F

                        mov     adr,x                   'get -bitcount into adr
                        sub     adr,y           wc      'c=1 if reverse
                        absneg  adr,adr
                        sub     adr,#1

        if_nc           mov     lsb,y                   'get lowest bit into lsb
        if_c            mov     lsb,x

                        muxnc   writev,maskwr           'clear/set reverse
                        muxnc   readv,maskwr

                        or      op,#%1100               'set bit mode
                        jmp     #mrop
'
'
' Upper codes
'
upper                   cmp     op,#$80         wc      'varop?
        if_c            jmp     #varop                  'c=1

                        cmp     op,#$E0         wc      'memop?
        if_c            jmp     #memop

                        mov     a,op            wz      'mathop follows (z=0)
'
'
' Math operation
'                               unary/
'       code    normal  assign  binary  description
'       ---------------------------------------------------------------
'       00000   ->      ->=     b       rotate right
'       00001   <-      <-=     b       rotate left
'       00010   >>      >>=     b       shift right
'       00011   <<      <<=     b       shift left
'       00100   |>      |>=     b       limit minimum (signed)
'       00101   <|      <|=     b       limit maximum (signed)
'       00110   -       -       u       negate
'       00111   !       !       u       bitwise not
'       01000   &       &=      b       bitwise and
'       01001   ||      ||      u       absolute
'       01010   |       |=      b       bitwise or
'       01011   ^       ^=      b       bitwise xor
'       01100   +       +=      b       add
'       01101   -       -=      b       subtract
'       01110   ~>      ~>=     b       shift arithmetic right
'       01111   ><      ><=     b       reverse bits
'       10000   AND             b       boolean and
'       10001   >|      >|      u       encode (0-32)
'       10010   OR              b       boolean or
'       10011   |<      |<      u       decode
'       10100   *       *=      b       multiply, return lower half (signed)
'       10101   **      **=     b       multiply, return upper half (signed)
'       10110   /       /=      b       divide, return quotient (signed)
'       10111   //      //=     b       divide, return remainder (signed)
'       11000   ^^      ^^      u       square root
'       11001   <               b       test below (signed)
'       11010   >               b       test above (signed)
'       11011   <>              b       test not equal
'       11100   ==              b       test equal
'       11101   =<              b       test below or equal (signed)
'       11110   =>              b       test above or equal (signed)
'       11111   NOT     NOT     u       boolean not
'
' z = swap binary arguments
'
mathop                  and     a,#%11111               'limit for mbol and mcod

                        ror     mathops,a               'unary or binary?
                        rol     mathops,a       wc

        if_nc           call    #popx                   'pop unary argument
        if_c            call    #popyx                  'pop binary arguments

        if_nc_or_z      xor     x,y                     'if unary or swap, swap x and y
        if_nc_or_z      xor     y,x
        if_nc_or_z      xor     x,y

                        mov     t1,#0

                        test    a,#%10000       wz      'jmp to operation
        if_nc           jmp     #muny
        if_z            jmp     #mcod
                        test    a,#%01000       wc
        if_c            jmp     #mtst

                        test    a,#%00100       wc      'boolean and/or?
        if_nc           cmp     x,#0            wz
        if_nc           muxnz   x,masklong
        if_nc           cmp     y,#0            wz
        if_nc           muxnz   y,masklong
        if_nc           jmp     #mcod2

                        mov     t2,#32                  'multiply/divide
                        abs     x,x             wc
                        muxc    a,#%01100
                        abs     y,y             wc,wz
        if_c            xor     a,#%00100
                        test    a,#%00010       wc
        if_c_and_nz     jmp     #mdiv                   'if divide and y=0, do multiply so result=0

                        shr     x,#1            wc      'multiply
mmul    if_c            add     t1,y            wc
                        rcr     t1,#1           wc
                        rcr     x,#1            wc
                        djnz    t2,#mmul
                        test    a,#%00100       wz
        if_nz           neg     t1,t1
        if_nz           neg     x,x             wz
        if_nz           sub     t1,#1
                        test    a,#%00001       wz
        if_nz           mov     x,t1
                        jmp     #push

mdiv                    shr     y,#1            wc,wz   'divide
                        rcr     t1,#1
        if_nz           djnz    t2,#mdiv
mdiv2                   cmpsub  x,t1            wc
                        rcl     y,#1
                        shr     t1,#1
                        djnz    t2,#mdiv2
                        test    a,#%01000       wc
                        negc    x,x
                        test    a,#%00100       wc
                        test    a,#%00001       wz
        if_z            negc    x,y
                        jmp     #push

mtst                    cmps    x,y             wc,wz   'tests
        if_z            mov     x,#%100                 'equal?
        if_nz           mov     x,#%010                 'above?
        if_c            mov     x,#%001                 'below?
                        andn    x,a             wz
mtst2                   muxz    x,masklong
                        jmp     #push

mcod                    cmp     a,#%01111       wz      'instruction-equivalents
        if_z            neg     y,y
                        mov     t1,a
                        and     t1,#%001100
                        add     a,t1
                        cmp     a,#%011010      wc
        if_nc           sub     a,#%010100
mcod2                   shl     a,#3
                        add     a,#%001000_001
                        movi    mcod3,a
maskpar                 long    $0000FFFC               'nop/constant
mcod3                   ror     x,y                     '(modifying)
                        jmp     #push

muny                    test    a,#%01000       wc      'unaries
        if_nz           jmp     #muny2

                        test    a,#%00001       wz
        if_nc           neg     x,y                     'neg
        if_nc_and_nz    sub     x,#1                    'bitwise not
        if_c            abs     x,y                     'abs
                        jmp     #push

muny2                   test    a,#%00010       wz
        if_c            jmp     #muny3

        if_z            mov     x,#32                   'encode
mncd    if_z            shl     y,#1            wc
        if_z_and_nc     djnz    x,#mncd

        if_nz           mov     x,#1                    'decode
        if_nz           shl     x,y
                        jmp     #push

muny3                   mov     x,#0                    'square root
        if_z            mov     t2,#16
msqr    if_z            shl     y,#1            wc
        if_z            rcl     t1,#1
        if_z            shl     y,#1            wc
        if_z            rcl     t1,#1
        if_z            shl     x,#2
        if_z            or      x,#1
        if_z            cmpsub  t1,x            wc
        if_z            shr     x,#2
        if_z            rcl     x,#1
        if_z            djnz    t2,#msqr

        if_nz           cmp     x,y             wc      'boolean not
        if_nz           muxnc   x,masklong

push                    wrlong  x,dcurr                 'push result
                        add     dcurr,#4
                        test    op2,#%01000000  wc      'mathop?
pushret                 jmp     #loop


mathops                 long    %1_01111110_11110101_11111101_0011111
'
'
' Variable operation (c=1)
'
varop                   mov     y,#%10                  'set long

                        mov     adr,op                  'isolate offset
                        and     adr,#%011100

                        test    op,#%100000     wz      'get vbase/dbase

                        jmp     #memopb                 'add base (c=1)
'
'
' Memory operation
'
memop                   mov     y,op                    'set size
                        shr     y,#5
                        and     y,#%11

                        test    op,#%0010000    wc      'index?

        if_c            call    #popx                   'yes, pop and scale
        if_c            shl     x,y

                        test    op,#%0001000    wc      'get base mode
                        test    op,#%0000100    wz

        if_nc_and_z     sub     dcurr,#4                'if no base, pop address
        if_nc_and_z     rdlong  adr,dcurr

        if_c_or_nz      movi    sarshr,#%001010_001     'if base, get zero-extended address
        if_c_or_nz      jmpret  getret,#getadrz
                        test    op,#%0001000    wc      'restore c
        if_c_or_nz      mov     adr,op2

                        add     adr,x                   'add any index

        if_nc_and_nz    add     adr,pbase               'if pbase, add
memopb  if_c_and_z      add     adr,vbase               'if vbase, add
        if_c_and_nz     add     adr,dbase               'if dbase, add

                        shl     y,#3                    'set read/write by size
                        movi    writem,y
                        or      y,#%000000_001
                        movi    readm,y

                        and     op,#%0011               'set type to memory (followed by mrop)
'
'
' Memory/register operation
'
mrop                    jmpret  getret,#getflags        'get op flags

        if_nc_and_z     jmp     #read                   'read?

        if_nc_and_nz    call    #popx                   'write?
        if_nc_and_nz    jmp     #write

        if_c_and_nz     mov     x,adr                   'address?
        if_c_and_nz     and     x,maskword
        if_c_and_nz     jmp     #push


                        jmpret  getret,#getop2          'assign, get assignment (c=1)

                        test    op2,#%01111110  wz      'write? (w/push)
        if_z            call    #popx
        if_z            jmp     #:keep

                        jmpret  pushret,#read           'modifier or mathop, read var (c=1 if mathop)

                        test    op2,#%00100000  wz

        if_c            mov     a,op2                   'mathop? set op, z=swap args
        if_c            jmpret  pushret,#mathop         'do math (c=1)
                        sub     dcurr,#4                'unpop var/result (in any case)
        if_c            jmp     #:keep                  'if mathop, write

                        test    op2,#%00010000  wc
        if_nz           jmp     #:incdec

                        test    op2,#%00000100  wz
        if_c            jmp     #:sxcs

                        test    op2,#%00001000  wc
        if_c            jmp     #:rnd

                        movd    popxr,#t1               'repeat-var loop?
                        call    #popayx                 'pop data (a=to, y=from, t1=step)
                        movd    popxr,#x
        if_z            add     dcurr,#4                'if step default, unpop step
        if_z            mov     t1,#1                   'if step default, set step to 1
                        jmpret  getret,#getadrs         'get address
                        cmps    a,y             wc      'reverse range?
                        sumc    x,t1                    'add/sub step to/from var
                        call    #range                  'check if x in range y..a according to c
        if_nc           add     pcurr,op2               'if in range, branch
                        jmp     #:restore

:rnd                    min     x,#1                    '?var/var?
                        mov     y,#32
                        mov     a,#%10111
        if_nz           ror     a,#1
:rndlp                  test    x,a             wc
        if_z            rcr     x,#1
        if_nz           rcl     x,#1
                        djnz    y,#:rndlp       wc      'c=0
                        jmp     #:stack

:sxcs                   test    op2,#%00001000  wc
        if_nc_and_z     shl     x,#24                   '~var/~~var
        if_nc_and_z     sar     x,#24
        if_nc_and_nz    shl     x,#16
        if_nc_and_nz    sar     x,#16
        if_c            muxnz   x,masklong              'var~/var~~
                        jmp     #:stack

:incdec                 sumc    x,#1                    '++var/var++/--var/var--
                        test    op2,#%00000100  wc      'mask result by size
                        test    op2,#%00000010  wz
        if_nc_and_z     rev     x,adr
        if_nc_and_z     rev     x,adr
        if_nc_and_nz    and     x,#$FF
        if_c_and_z      and     x,maskword
                        test    op2,#%00001000  wc      'pre-inc/dec or post-inc/dec?

:stack  if_nc           wrlong  x,dcurr                 'if not var~/var~~/var++/var--, write stack

:keep                   test    op2,#%10000000  wc      'keep value on stack?
        if_c            add     dcurr,#4                '(followed by write)

:restore                movs    pushret,#loop           'restore pushret, followed by write
'
'
' Write memory/register
'
write                   test    op,#%1100       wc,wz   'get type into flags

writem  if_z            wrlong  x,adr                   'memory?
        if_z            jmp     #loop

        if_nc           neg     a,#1                    'register field?
        if_nc           rev     a,adr
        if_nc           shl     a,lsb
        if_nc           xor     a,masklong
        if_nc           rev     x,adr
writev  if_nc           rev     x,adr
        if_nc           shl     x,lsb
writef  if_nc           and     a,$1FF
        if_nc           or      x,a
writer                  mov     $1FF,x                  'register
                        jmp     #loop
'
'
' Read memory/register
'
read                    test    op,#%1100       wc,wz   'get type into flags

readm   if_z            rdlong  x,adr                   'memory?
        if_z            jmp     #push

readr                   mov     x,$1FF                  'register
        if_nc           shr     x,lsb                   'register field?
        if_nc           rev     x,adr
readv   if_nc           rev     x,adr
                        jmp     #push
'
'
' Get address
'
getadrs                 movi    sarshr,#%001110_001     'set sign-extended

getadrz                 rdbyte  op2,pcurr               'get first byte
                        add     pcurr,#1
                        test    op2,#$80        wc      'if bit7 set, another byte

                        shl     op2,#25                 'sign/zero-extend from bit6
sarshr                  sar     op2,#25                 'sar for jX / shr for memop

getop2  if_c            rdbyte  t2,pcurr                'if another byte, get second byte and shift in
        if_c            add     pcurr,#1
        if_c            shl     op2,#8
        if_c            or      op2,t2

                        jmp     #getc                   'restore c for jX
'
'
' Pops
'
popayx                  sub     dcurr,#4
                        rdlong  a,dcurr

popyx                   sub     dcurr,#4
                        rdlong  y,dcurr

popx                    sub     dcurr,#4
popxr                   rdlong  x,dcurr

popx_ret
popyx_ret
popayx_ret              ret
'
'
' Check range
' must be preceded by:  cmps    a,y             wc
'
range   if_c            xor     a,y                     'if reverse range, swap range values
        if_c            xor     y,a
        if_c            xor     a,y

                        cmps    x,y             wc      'c=0 if x within range
        if_nc           cmps    a,x             wc

range_ret               ret
'
'
' Constants
'
masklong                long    $FFFFFFFF               '(temporarily used by runner code)
masktop                 long    $80000000               '(temporarily used by runner code)
maskwr                  long    $00800000               '(temporarily used by runner code)
'
'
' Variables
'
lsb                     res     1
id                      res     1
dcall                   res     1
pbase                   res     1
vbase                   res     1
dbase                   res     1
pcurr                   res     1
dcurr                   res     1

                        org

x                       res     1                       'these 8 occupy the entry-code space
y                       res     1
a                       res     1
t1                      res     1
t2                      res     1
op                      res     1
op2                     res     1
adr                     res     1
