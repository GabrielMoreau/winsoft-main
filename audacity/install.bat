REM @ECHO OFF

REM
REM   Audacity
REM

REM Name
SET softname=Audacity

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__

REM Silent install
audacity-win-%softversion%-x64.exe /TASKS="!desktopicon,!resetprefs" /VERYSILENT /NORESTART /LOG="%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
