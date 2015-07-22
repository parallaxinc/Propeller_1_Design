' Cog LED test
'
' Starts each cog in succession, to verify that the cogs and LEDs are working on the P1V.


pub Start | i

repeat
  repeat i from 1 to 7
    coginit(i, donothing, 16384 + i * 40)
    waitcnt(10_000_000 + cnt)

  repeat i from 1 to 7
    cogstop(i)

  waitcnt(10_000_000 + cnt)

pub donothing

  repeat 
    par := 0