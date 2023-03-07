REM @ECHO OFF

REM
REM   XnViewMP
REM

REM Name
SET softname=XnViewMP

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=91.5.1
SET softpatch=1


ECHO Silent install %softname%
XnViewMP-win-%softversion%-x64.exe /VERYSILENT /NORESTART /SUPPRESSMSGBOXES /MERGETASKS=!desktopicon /LOG="%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
