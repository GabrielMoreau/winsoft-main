REM @ECHO OFF

REM
REM   VMwareHorizon
REM

REM Name
SET softname=VMwareHorizon

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSIONLONG__


ECHO Silent install %softname%
VMware-Horizon-Client-%softversion%.exe /silent /install /norestart /log "%logdir%\%softname%-MSI.log" DESKTOP_SHORTCUT=0


ECHO END %date%-%time%
EXIT
