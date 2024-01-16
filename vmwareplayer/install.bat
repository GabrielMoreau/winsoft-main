
REM
REM   VMwarePlayer
REM

REM Name
SET softname=VMwarePlayer

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
VMware-player-full-%softversion%.exe /s /v "/qn EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0 ADDLOCAL=ALL DESKTOP_SHORTCUT=0 STARTMENU_SHORTCUT=1 REBOOT=ReallySuppress"


ECHO END %date%-%time%
EXIT
