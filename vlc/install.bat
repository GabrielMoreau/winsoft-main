REM @ECHO OFF

REM
REM   VLC
REM

REM Name
SET softname=VideoLAN-VLC-Media-Player

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=3.0.13
SET softpatch=1


REM Silent install
"vlc-%softversion%-win64.exe" /S /NCRC


ECHO END %date%-%time%
EXIT
