REM @ECHO OFF

REM
REM   BvSshClient
REM

REM Name
SET softname=BvSshClient

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


ECHO Silent install %softname%
BvSshClient-Inst-%softversion%.exe -acceptEULA -noDesktopIcon=y -autoUpdates=0


ECHO END %date%-%time%
EXIT
