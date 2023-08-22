REM @ECHO OFF

REM
REM   GitForWindows
REM

REM Name
SET softname=GitForWindows

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__
SET softpatch=__PATCH__

REM Silent install
Git-%softversion%-64-bit.exe /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS


ECHO END %date%-%time%
EXIT
