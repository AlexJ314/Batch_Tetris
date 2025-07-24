rem  tetris.bat
rem  https://tetris.fandom.com/wiki/SRS
rem  https://tetris.fandom.com/wiki/Tetris_Guideline



rem  set up environment
@echo off
setlocal enabledelayedexpansion
set "pressable=qpwasdijklzxcbnmv"


if _%1==_ (
  title Tetris
  cls
  echo. > ./keys
  start cmd /c %0 2
)

if _%1==_ (
  call :display
)

if _%1==_2 (
  call :listener
)

exit /b


rem  Runs on cmd and listens for user I/O
:listener
  title Tetris - Inputs
  cls
  echo Keep this window focused to control the game
  echo.
  echo Q : Quit
  echo P : Pause
  echo J or A : Left
  echo L or D : Right
  echo X or I or N or W : Clockwise
  echo Z or K or B or S : Counter-Clockwise
  echo C or M : Hold
  echo V : Drop
  echo.
  set "keys="
  set /a id=0
  call :inputLoop
  echo Done listening
exit /b


rem  Input loop
:inputLoop
  choice /c %pressable% /n > nul
  set err=!errorlevel!
  set "key=_!err!"
  set "key=!key:~-2!"
  set "paddedID=_!id!"
  set "paddedID=!paddedID:~-2!"
  set "keys=!keys!!paddedID!!key!"
  set "keys=!keys:~-64!"
  echo !keys! > ./keys
  if !err! LEQ 1 (
    exit /b
  )
  set /a id+=1
  if !id! GEQ 100 (
    set /a id=0
  )
  goto :inputLoop
goto :eof



rem  Does game loop and tries reading from keystrokes file
:display


rem  NOT USED
rem  set up :disp for colour display
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
<nul > print set /p ".=."


rem  Define board
for /l %%r in (-4,1,20) do (
  for /l %%c in (0,1,9) do (
    set board.%%r_%%c=`
  )
)


rem  Initialize stats
set score=0
set lines=0


rem  define pieces
  set /a tet.active_row=-1
  set /a tet.active_col=4
  set /a tet.rot=0
  call :rand tet.shape 0 6
  call :rand tet.next 0 6
  set /a tet.held_piece=-1
  set /a tet.can_hold=1

  rem  shape_rotation_sub-block

  rem Light Aqua I
    rem set tet.0_colour=B
    set tet.0_colour=I

    set /a tet.0_0_0_row=-1
    set /a tet.0_0_0_col=-1
    set /a tet.0_0_1_row=-1
    set /a tet.0_0_1_col=0
    set /a tet.0_0_2_row=-1
    set /a tet.0_0_2_col=1
    set /a tet.0_0_3_row=-1
    set /a tet.0_0_3_col=2

    set /a tet.0_1_0_row=-2
    set /a tet.0_1_0_col=1
    set /a tet.0_1_1_row=-1
    set /a tet.0_1_1_col=1
    set /a tet.0_1_2_row=0
    set /a tet.0_1_2_col=1
    set /a tet.0_1_3_row=1
    set /a tet.0_1_3_col=1

    set /a tet.0_2_0_row=0
    set /a tet.0_2_0_col=-1
    set /a tet.0_2_1_row=0
    set /a tet.0_2_1_col=0
    set /a tet.0_2_2_row=0
    set /a tet.0_2_2_col=1
    set /a tet.0_2_3_row=0
    set /a tet.0_2_3_col=2

    set /a tet.0_3_0_row=-2
    set /a tet.0_3_0_col=0
    set /a tet.0_3_1_row=-1
    set /a tet.0_3_1_col=0
    set /a tet.0_3_2_row=0
    set /a tet.0_3_2_col=0
    set /a tet.0_3_3_row=1
    set /a tet.0_3_3_col=0

  rem  Blue J
    rem set tet.1_colour=1
    set tet.1_colour=J

    set /a tet.1_0_0_row=-1
    set /a tet.1_0_0_col=-1
    set /a tet.1_0_1_row=0
    set /a tet.1_0_1_col=-1
    set /a tet.1_0_2_row=0
    set /a tet.1_0_2_col=0
    set /a tet.1_0_3_row=0
    set /a tet.1_0_3_col=1

    set /a tet.1_1_0_row=-1
    set /a tet.1_1_0_col=1
    set /a tet.1_1_1_row=-1
    set /a tet.1_1_1_col=0
    set /a tet.1_1_2_row=0
    set /a tet.1_1_2_col=0
    set /a tet.1_1_3_row=1
    set /a tet.1_1_3_col=0

    set /a tet.1_2_0_row=0
    set /a tet.1_2_0_col=-1
    set /a tet.1_2_1_row=0
    set /a tet.1_2_1_col=0
    set /a tet.1_2_2_row=0
    set /a tet.1_2_2_col=1
    set /a tet.1_2_3_row=1
    set /a tet.1_2_3_col=1

    set /a tet.1_3_0_row=1
    set /a tet.1_3_0_col=-1
    set /a tet.1_3_1_row=1
    set /a tet.1_3_1_col=0
    set /a tet.1_3_2_row=0
    set /a tet.1_3_2_col=0
    set /a tet.1_3_3_row=-1
    set /a tet.1_3_3_col=0

  rem Yellow L
    rem set tet.2_colour=6
    set tet.2_colour=L

    set /a tet.2_0_0_row=0
    set /a tet.2_0_0_col=-1
    set /a tet.2_0_1_row=0
    set /a tet.2_0_1_col=0
    set /a tet.2_0_2_row=0
    set /a tet.2_0_2_col=1
    set /a tet.2_0_3_row=-1
    set /a tet.2_0_3_col=1

    set /a tet.2_1_0_row=-1
    set /a tet.2_1_0_col=0
    set /a tet.2_1_1_row=0
    set /a tet.2_1_1_col=0
    set /a tet.2_1_2_row=1
    set /a tet.2_1_2_col=0
    set /a tet.2_1_3_row=1
    set /a tet.2_1_3_col=1

    set /a tet.2_2_0_row=0
    set /a tet.2_2_0_col=-1
    set /a tet.2_2_1_row=0
    set /a tet.2_2_1_col=0
    set /a tet.2_2_2_row=0
    set /a tet.2_2_2_col=1
    set /a tet.2_2_3_row=1
    set /a tet.2_2_3_col=-1

    set /a tet.2_3_0_row=-1
    set /a tet.2_3_0_col=-1
    set /a tet.2_3_1_row=-1
    set /a tet.2_3_1_col=0
    set /a tet.2_3_2_row=0
    set /a tet.2_3_2_col=0
    set /a tet.2_3_3_row=1
    set /a tet.2_3_3_col=0

  rem Light Yellow O
    rem set tet.3_colour=E
    set tet.3_colour=O
    

    set /a tet.3_0_0_row=-1
    set /a tet.3_0_0_col=0
    set /a tet.3_0_1_row=0
    set /a tet.3_0_1_col=0
    set /a tet.3_0_2_row=-1
    set /a tet.3_0_2_col=1
    set /a tet.3_0_3_row=0
    set /a tet.3_0_3_col=1

  rem Light Green S
    rem set tet.4_colour=A
    set tet.4_colour=S

    set /a tet.4_0_0_row=0
    set /a tet.4_0_0_col=-1
    set /a tet.4_0_1_row=0
    set /a tet.4_0_1_col=0
    set /a tet.4_0_2_row=-1
    set /a tet.4_0_2_col=0
    set /a tet.4_0_3_row=-1
    set /a tet.4_0_3_col=1

    set /a tet.4_1_0_row=-1
    set /a tet.4_1_0_col=0
    set /a tet.4_1_1_row=0
    set /a tet.4_1_1_col=0
    set /a tet.4_1_2_row=0
    set /a tet.4_1_2_col=1
    set /a tet.4_1_3_row=1
    set /a tet.4_1_3_col=1

    set /a tet.4_2_0_row=1
    set /a tet.4_2_0_col=-1
    set /a tet.4_2_1_row=1
    set /a tet.4_2_1_col=0
    set /a tet.4_2_2_row=0
    set /a tet.4_2_2_col=0
    set /a tet.4_2_3_row=0
    set /a tet.4_2_3_col=1

    set /a tet.4_3_0_row=-1
    set /a tet.4_3_0_col=-1
    set /a tet.4_3_1_row=0
    set /a tet.4_3_1_col=-1
    set /a tet.4_3_2_row=0
    set /a tet.4_3_2_col=0
    set /a tet.4_3_3_row=1
    set /a tet.4_3_3_col=0

  rem Light Purple T
    rem set tet.5_colour=D
    set tet.5_colour=T

    set /a tet.5_0_0_row=0
    set /a tet.5_0_0_col=-1
    set /a tet.5_0_1_row=0
    set /a tet.5_0_1_col=0
    set /a tet.5_0_2_row=0
    set /a tet.5_0_2_col=1
    set /a tet.5_0_3_row=-1
    set /a tet.5_0_3_col=0

    set /a tet.5_1_0_row=-1
    set /a tet.5_1_0_col=0
    set /a tet.5_1_1_row=0
    set /a tet.5_1_1_col=0
    set /a tet.5_1_2_row=1
    set /a tet.5_1_2_col=0
    set /a tet.5_1_3_row=0
    set /a tet.5_1_3_col=1

    set /a tet.5_2_0_row=0
    set /a tet.5_2_0_col=-1
    set /a tet.5_2_1_row=0
    set /a tet.5_2_1_col=0
    set /a tet.5_2_2_row=0
    set /a tet.5_2_2_col=1
    set /a tet.5_2_3_row=1
    set /a tet.5_2_3_col=0

    set /a tet.5_3_0_row=-1
    set /a tet.5_3_0_col=0
    set /a tet.5_3_1_row=0
    set /a tet.5_3_1_col=0
    set /a tet.5_3_2_row=1
    set /a tet.5_3_2_col=0
    set /a tet.5_3_3_row=0
    set /a tet.5_3_3_col=-1

  rem Red Z
    rem set tet.6_colour=4
    set tet.6_colour=Z

    set /a tet.6_0_0_row=-1
    set /a tet.6_0_0_col=-1
    set /a tet.6_0_1_row=-1
    set /a tet.6_0_1_col=0
    set /a tet.6_0_2_row=0
    set /a tet.6_0_2_col=0
    set /a tet.6_0_3_row=0
    set /a tet.6_0_3_col=1

    set /a tet.6_1_0_row=-1
    set /a tet.6_1_0_col=1
    set /a tet.6_1_1_row=0
    set /a tet.6_1_1_col=1
    set /a tet.6_1_2_row=0
    set /a tet.6_1_2_col=0
    set /a tet.6_1_3_row=1
    set /a tet.6_1_3_col=0

    set /a tet.6_2_0_row=0
    set /a tet.6_2_0_col=-1
    set /a tet.6_2_1_row=0
    set /a tet.6_2_1_col=0
    set /a tet.6_2_2_row=1
    set /a tet.6_2_2_col=0
    set /a tet.6_2_3_row=1
    set /a tet.6_2_3_col=1

    set /a tet.6_3_0_row=-1
    set /a tet.6_3_0_col=0
    set /a tet.6_3_1_row=0
    set /a tet.6_3_1_col=0
    set /a tet.6_3_2_row=0
    set /a tet.6_3_2_col=-1
    set /a tet.6_3_3_row=1
    set /a tet.6_3_3_col=-1

rem  define wall kicks
rem  Kick type_state_test

  rem  I
    set /a kick.0_01_0_row=0
    set /a kick.0_01_0_col=0
    set /a kick.0_01_1_row=0
    set /a kick.0_01_1_col=-2
    set /a kick.0_01_2_row=0
    set /a kick.0_01_2_col=1
    set /a kick.0_01_3_row=-1
    set /a kick.0_01_3_col=-2
    set /a kick.0_01_4_row=2
    set /a kick.0_01_4_col=1

    set /a kick.0_10_0_row=0
    set /a kick.0_10_0_col=0
    set /a kick.0_10_1_row=0
    set /a kick.0_10_1_col=2
    set /a kick.0_10_2_row=0
    set /a kick.0_10_2_col=-1
    set /a kick.0_10_3_row=1
    set /a kick.0_10_3_col=2
    set /a kick.0_10_4_row=-2
    set /a kick.0_10_4_col=-1

    set /a kick.0_12_0_row=0
    set /a kick.0_12_0_col=0
    set /a kick.0_12_1_row=0
    set /a kick.0_12_1_col=-1
    set /a kick.0_12_2_row=0
    set /a kick.0_12_2_col=2
    set /a kick.0_12_3_row=2
    set /a kick.0_12_3_col=-1
    set /a kick.0_12_4_row=-1
    set /a kick.0_12_4_col=2

    set /a kick.0_21_0_row=0
    set /a kick.0_21_0_col=0
    set /a kick.0_21_1_row=0
    set /a kick.0_21_1_col=1
    set /a kick.0_21_2_row=0
    set /a kick.0_21_2_col=-2
    set /a kick.0_21_3_row=-2
    set /a kick.0_21_3_col=1
    set /a kick.0_21_4_row=1
    set /a kick.0_21_4_col=-2

    set /a kick.0_23_0_row=0
    set /a kick.0_23_0_col=0
    set /a kick.0_23_1_row=0
    set /a kick.0_23_1_col=2
    set /a kick.0_23_2_row=0
    set /a kick.0_23_2_col=-1
    set /a kick.0_23_3_row=1
    set /a kick.0_23_3_col=2
    set /a kick.0_23_4_row=-2
    set /a kick.0_23_4_col=-1

    set /a kick.0_32_0_row=0
    set /a kick.0_32_0_col=0
    set /a kick.0_32_1_row=0
    set /a kick.0_32_1_col=-2
    set /a kick.0_32_2_row=0
    set /a kick.0_32_2_col=1
    set /a kick.0_32_3_row=-1
    set /a kick.0_32_3_col=-2
    set /a kick.0_32_4_row=2
    set /a kick.0_32_4_col=1

    set /a kick.0_30_0_row=0
    set /a kick.0_30_0_col=0
    set /a kick.0_30_1_row=0
    set /a kick.0_30_1_col=1
    set /a kick.0_30_2_row=0
    set /a kick.0_30_2_col=-2
    set /a kick.0_30_3_row=-2
    set /a kick.0_30_3_col=1
    set /a kick.0_30_4_row=1
    set /a kick.0_30_4_col=-2

    set /a kick.0_03_0_row=0
    set /a kick.0_03_0_col=0
    set /a kick.0_03_1_row=0
    set /a kick.0_03_1_col=-1
    set /a kick.0_03_2_row=0
    set /a kick.0_03_2_col=2
    set /a kick.0_03_3_row=2
    set /a kick.0_03_3_col=-1
    set /a kick.0_03_4_row=-1
    set /a kick.0_03_4_col=2

  rem  J, L, T, S, Z
    set /a kick.1_01_0_row=0
    set /a kick.1_01_0_col=0
    set /a kick.1_01_1_row=0
    set /a kick.1_01_1_col=-1
    set /a kick.1_01_2_row=1
    set /a kick.1_01_2_col=-1
    set /a kick.1_01_3_row=-2
    set /a kick.1_01_3_col=0
    set /a kick.1_01_4_row=-2
    set /a kick.1_01_4_col=-1

    set /a kick.1_10_0_row=0
    set /a kick.1_10_0_col=0
    set /a kick.1_10_1_row=0
    set /a kick.1_10_1_col=1
    set /a kick.1_10_2_row=-1
    set /a kick.1_10_2_col=1
    set /a kick.1_10_3_row=2
    set /a kick.1_10_3_col=0
    set /a kick.1_10_4_row=2
    set /a kick.1_10_4_col=1

    set /a kick.1_12_0_row=0
    set /a kick.1_12_0_col=0
    set /a kick.1_12_1_row=0
    set /a kick.1_12_1_col=1
    set /a kick.1_12_2_row=-1
    set /a kick.1_12_2_col=1
    set /a kick.1_12_3_row=2
    set /a kick.1_12_3_col=0
    set /a kick.1_12_4_row=2
    set /a kick.1_12_4_col=1

    set /a kick.1_21_0_row=0
    set /a kick.1_21_0_col=0
    set /a kick.1_21_1_row=0
    set /a kick.1_21_1_col=-1
    set /a kick.1_21_2_row=1
    set /a kick.1_21_2_col=-1
    set /a kick.1_21_3_row=-2
    set /a kick.1_21_3_col=0
    set /a kick.1_21_4_row=-2
    set /a kick.1_21_4_col=-1

    set /a kick.1_23_0_row=0
    set /a kick.1_23_0_col=0
    set /a kick.1_23_1_row=0
    set /a kick.1_23_1_col=1
    set /a kick.1_23_2_row=1
    set /a kick.1_23_2_col=1
    set /a kick.1_23_3_row=-2
    set /a kick.1_23_3_col=0
    set /a kick.1_23_4_row=-2
    set /a kick.1_23_4_col=1

    set /a kick.1_32_0_row=0
    set /a kick.1_32_0_col=0
    set /a kick.1_32_1_row=0
    set /a kick.1_32_1_col=-1
    set /a kick.1_32_2_row=-1
    set /a kick.1_32_2_col=-1
    set /a kick.1_32_3_row=2
    set /a kick.1_32_3_col=0
    set /a kick.1_32_4_row=2
    set /a kick.1_32_4_col=-1

    set /a kick.1_30_0_row=0
    set /a kick.1_30_0_col=0
    set /a kick.1_30_1_row=0
    set /a kick.1_30_1_col=-1
    set /a kick.1_30_2_row=-1
    set /a kick.1_30_2_col=-1
    set /a kick.1_30_3_row=2
    set /a kick.1_30_3_col=0
    set /a kick.1_30_4_row=2
    set /a kick.1_30_4_col=-1

    set /a kick.1_03_0_row=0
    set /a kick.1_03_0_col=0
    set /a kick.1_03_1_row=0
    set /a kick.1_03_1_col=1
    set /a kick.1_03_2_row=1
    set /a kick.1_03_2_col=1
    set /a kick.1_03_3_row=-2
    set /a kick.1_03_3_col=0
    set /a kick.1_03_4_row=-2
    set /a kick.1_03_4_col=1


rem  start the program
set /a nextid=0
set "key="
set gameover=0
set paused=0
set /a score=0
rem  In hundredths of a second
set /a tickDelay=50
call :getTime now
set /a lastTick=!now!
call :gameLoop
exit /b


rem  coloured text display
:disp <hex colour> <string> <new line?>
  set "param=^%~2" !
  set "param=!param:"=\"!"
  findstr /p /A:%1 "." "!param!\..\print" nul
  <nul set /p ".=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
  if "%~3" == "1" (
    echo.
  )
goto :eof


rem  Read in ids and keys from file
:getKeyLoop
  set "key="
  set buffer=0
  @for /f %%k in (./keys) do (
    set "keys=%%k"
    :parseKeys
      rem  read not empty
      if not _!keys!==_ (
        set "id=!keys:~0,2!"
        set "t=!id:~0,1!"
        if !t!==_ (
          set "id=!id:~1,1!"
        )
        set "key=!keys:~2,2!"
        set "t=!key:~0,1!"
        if !t!==_ (
          set "key=!key:~1,1!"
        )
        set "keys=!keys:~4,64!"
        rem  find the id
        if !id!==!nextid! (
          set /a nextid+=1
          if !nextid! GEQ 100 (
            set /a nextid=0
          )
          if not _!key!==_ (
            call :action_!key!
            set buffer=1
          )
        )
        goto :parseKeys
      )
    set "key="
    goto :eof
  )
goto :eof


rem  no action
:action_
goto :eof


rem  QUIT
:action_1
  set gameover=1
  set paused=1
goto :eof


rem  PAUSE
:action_2
  if !paused!==0 (
    set paused=1
  ) else (
    set paused=0
  )
goto :eof


rem  CLOCKWISE
:action_3
:action_7
:action_12
:action_15
  if !paused!==0 (
    call :rotate 1
  )
goto :eof


rem  LEFT
:action_4
:action_8
  if !paused!==0 (
    call :remove_piece
    set /a tet.active_col+=-1
    call :add_piece ret
    if !ret!==1 (
      set /a tet.active_col+=1
      call :add_piece ret
    )
  )
goto :eof


rem  COUNTER-CLOCKWISE
:action_5
:action_9
:action_11
:action_14
  if !paused!==0 (
    call :rotate -1
  )
goto :eof


rem  RIGHT
:action_6
:action_10
  if !paused!==0 (
    call :remove_piece
    set /a tet.active_col+=1
    call :add_piece ret
    if !ret!==1 (
      set /a tet.active_col+=-1
      call :add_piece ret
    )
  )
goto :eof


rem  HOLD <TODO>
:action_13
:action_16
  if !paused!==0 (
    echo HOLD
  )
goto :eof


rem  DROP
:action_17
  if !paused!==0 (
    :drop
    call :tick
    if !ret!==0 (
      goto :drop
    )
  )
goto :eof


rem  Get current time in hundredths of a second
rem  Result in %~1
:getTime <return>
  set "rawTime=%time%"
  if "_%rawTime:~0,1%"=="_ " (
    set /a "%~1=(1%rawTime:~1,1%-10)*360000 + (1%rawTime:~3,2%-100)*6000 + (1%rawTime:~6,2%-100)*100 + (1%rawTime:~9,2%-100)"
  ) else (
    set /a "%~1=(1%rawTime:~0,2%-100)*360000 + (1%rawTime:~3,2%-100)*6000 + (1%rawTime:~6,2%-100)*100 + (1%rawTime:~9,2%-100)"
  )
goto :eof


rem  Remove current piece from game board
:remove_piece
  for /l %%f in (0,1,3) do (
    set /a r=!tet.active_row!+!tet.%tet.shape%_%tet.rot%_%%f_row!
    set /a c=!tet.active_col!+!tet.%tet.shape%_%tet.rot%_%%f_col!
    set board.!r!_!c!=`
  )
goto :eof


rem  Add current piece to game board
:add_piece <return value>
  call :add_offset_piece %~1 0 0
goto :eof


rem  Add current piece to game board with offset
:add_offset_piece <return value> <row> <col>
  set ret=0
  for /l %%a in (0,1,3) do (
    set /a r=!tet.active_row!+!tet.%tet.shape%_%tet.rot%_%%a_row!+%~2
    set /a c=!tet.active_col!+!tet.%tet.shape%_%tet.rot%_%%a_col!+%~3
    if !r! GTR 20 (
      set ret=1
    )
    if !c! LSS 0 (
      set ret=1
    )
    if !c! GTR 9 (
      set ret=1
    )
    if !ret!==0 (
      set "func=^!board.!r!_!c!^!"
      for %%d in (!func!) do (
        set b=%%d
      )
      if not !b!==` (
        set ret=1
      )
    )
  )
  if !ret!==0 (
    for /l %%a in (0,1,3) do (
      set /a r=!tet.active_row!+!tet.%tet.shape%_%tet.rot%_%%a_row!+%~2
      set /a c=!tet.active_col!+!tet.%tet.shape%_%tet.rot%_%%a_col!+%~3
      set board.!r!_!c!=!tet.%tet.shape%_colour!
    )
  )
  set %~1=!ret!
goto :eof


rem  Add a new piece to game board
:new_piece
  set /a tet.active_row=-1
  set /a tet.active_col=4
  set /a tet.rot=0
  call :rand tet.shape 0 6
  set /a tet.can_hold=1
  call :add_piece ret
  if !ret!==1 (
    call :game_over
  )
goto :eof


rem  Clears row
:clear_row <row>
  for /l %%h in (%~1,-1,0) do (
    for /l %%i in (0,1,9) do (
      set /a jh=%%h-1
      for %%j in (!jh!) do (
        set board.%%h_%%i=!board.%%j_%%i!
      )
    )
  )
goto :eof


rem  Checks if rows are full
:check_rows
  set cleared=0
  for /l %%l in (1,1,20) do (
    set /a full=0
    for /l %%m in (0,1,9) do (
      if not !board.%%l_%%m!==` (
        set /a full+=1
      )
    )
    if !full!==10 (
      set /a cleared+=1
      call :clear_row %%l
    )
  )
goto :eof


rem  Game tick
:tick
  set /a lastTick=!now!
  if !paused!==0 (
    set buffer=1
    call :remove_piece
    set /a tet.active_row+=1
    call :add_piece ret
    if !ret!==1 (
      set /a tet.active_row+=-1
      call :add_piece ret
      call :check_rows
      call :new_piece
      set ret=1
    )
  )
goto :eof


rem  Print board
:print
  set out=############^


  for /l %%r in (1,1,20) do (
    set out=!out!#
    for /l %%c in (0,1,9) do (
      set "t=!board.%%r_%%c!"
      if !t!==` (
        set /a tt=%%c / 2
        set /a tt*=2
        if !tt!==%%c (
          set "t= "
        ) else (
          set "t=,"
        )
      )
      set "out=!out!!t!"
    )
    set out=!out!#^


  )
  cls&echo !out!############
goto :eof


rem  Try rotating the piece
:rotate <direction>
  if not !tet.shape!==3 (
    call :remove_piece
    set lr=!tet.rot!
    set /a tet.rot+=%~1
    if !tet.rot! GTR 3 (
      set tet.rot=0
    )
    if !tet.rot! LSS 0 (
      set tet.rot=3
    )
    set sh=0
    if not !tet.shape!==0 (
      set sh=1
    )
    set try=0
    :retry
    for %%e in (!sh!_!lr!!tet.rot!_!try!) do (
      call :add_offset_piece ret !kick.%%e_row! !kick.%%e_col!
      if !ret!==1 (
        set /a try+=1
        if !try! GTR 4 (
          set /a tet.rot=!lr!
          call :add_piece ret
        ) else (
          goto :retry
        )
      ) else (
        set /a tet.active_row+=!kick.%%e_row!
        set /a tet.active_col+=!kick.%%e_col!
      )
    )
  )
goto :eof


rem  Get random int <TODO> do a grab-bag of all 7 pieces
rem  Stored in %~1
:rand <return> <min> <max>
  set /a %~1=((%~3-%~2)*%RANDOM%)/32768+%~2
goto :eof


rem  Game over
:game_over
  call :print
  set gameover=1
  exit /b
goto :eof


:gameLoop
  call :getKeyLoop
  call :getTime now
  set /a elapsed=!now!-!lastTick!
  if !elapsed! GEQ !tickDelay! (
    call :tick
  ) else (
    if !now! LSS !lastTick! (
      set /a elapsed=!lastTick!-!now!
      if !elapsed! GEQ !tickDelay! (
        call :tick
      )
    )
  )
  if !buffer!==1 (
    call :print
  )
  if !gameover!==0 (
    goto :gameLoop
  )
  exit /b
goto :eof


endlocal


rem  Todo:
rem    Hold piece / swap
rem    Show next piece
rem    Grab-bag of next 7 pieces (instead of random int)
rem    Levels
rem      Scoring
rem      Speeding up
rem    Show drop location
