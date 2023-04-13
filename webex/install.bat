REM @ECHO OFF

REM
REM   Webex
REM

REM Name
SET softname=Webex

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
msiexec /i "Webex-%softversion%.msi" ACCEPT_EULA=TRUE ALLUSERS=1 AUTOUPGRADEENABLED=0 AUTOSTART_WITH_WINDOWS=False /qn /L*v "%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
