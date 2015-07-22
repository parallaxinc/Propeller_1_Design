'       **********************************************************************************************
'       *                                                                                            *
'       *       PNut Runner                                                                          *
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
' Run code
' - builds new stack and launches interpreter
' - jumped to by 'run' instruction
'
CON

  #5, masklong, masktop, maskwr                         'constants
  lsb, id, dcall, pbase, vbase, dbase, pcurr, dcurr     'variables

  stack = masklong      '$FFFFFFFF                      'aliases
  subid = masktop       '$80000000
  parms = maskwr        '$00800000
  psave = lsb

  regop = $3F, r = $80, w = $A0, o = $C0

  interp = $F004
'
'
' Start code
'
DAT

first   byte    regop, w + stack                'pop and write stack (entry)
        byte    regop, o + subid, $80           'pop and write subid (leave on stack)

        byte    $38, 8, $E2, $38, 2, $E3        'parms := subid >> 8 << 2
        byte    regop, w + parms

        byte    regop, r + subid                'subid := @pbase.long[subid & $FF]
        byte    $38, $FF, $E8, $D7, $00
        byte    regop, w + subid

        byte    regop, r + stack, $38, 12, $EC  'bytemove(stack + 12, dcurr - 4 - parms, parms)
        byte    regop, r + dcurr
        byte    $38, 4, $ED
        byte    regop, r + parms, $ED
        byte    regop, r + parms, $1C

        byte    regop, r + parms, $14           'pop(parms)

        byte    $34                             'long[stack] := $FFFFFFFF
        byte    regop, r + stack, $C1

        byte    $3B, $FF, $F9, $FF, $FF         'long[stack][1] := $FFF9FFFF
        byte    regop, r + stack, $36, $D1

        byte    $35                             'long[stack][2] := 0
        byte    regop, r + stack, $38, 2, $D1

        byte    regop, r + stack, $38, 12, $EC  'parms += stack + 12
        byte    regop, o + parms, $4C

        byte    regop, r + pbase                'word[parms][1] := pbase
        byte    regop, r + parms, $36, $B1

        byte    regop, r + vbase                'word[parms][2] := vbase
        byte    regop, r + parms, $38, 2, $B1

        byte    regop, r + stack, $38, 8, $EC   'word[parms][3] := stack + 8
        byte    regop, r + parms, $38, 3, $B1

        byte    regop, r + subid, $A0, $97, $00 'word[parms][4] := @pbase.byte[word[subid]]
        byte    regop, r + parms, $38, 4, $B1

        byte    regop, r + subid, $36, $B0      'word[parms][5] := parms + word[subid][1]
        byte    regop, r + parms, $EC
        byte    regop, r + parms, $38, 5, $B1

        byte    $34                             'push params for coginit(-1, interp, parms)
        byte    $39, interp >> 8, interp
        byte    regop, r + parms

        byte    regop, r + psave                'push psave

        byte    $34                             'restore masklong to $FFFFFFFF
        byte    regop, w + masklong

        byte    $37, $1E                        'restore masktop to $80000000
        byte    regop, w + masktop

        byte    $37, $16                        'restore maskwr to $00800000
        byte    regop, w + maskwr

        byte    regop, w + pcurr                'pop and write pcurr (return to caller)
'
'
' Position stop code and entry code
'
        long
        byte    0
'
'
' Stop code at $FFF9
'
        byte    regop, r + id, $21              'cogstop(cogid)
'
'
' Entry code at $FFFC
'
        byte    $04                             'jmp start
        byte    (@first - @last) >> 8
        byte    @first - @last

last    byte    $01                             'chip version
