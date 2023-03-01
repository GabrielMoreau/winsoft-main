REM @ECHO OFF

REM
REM   VeraCrypt
REM

REM Name
SET softname=VeraCrypt

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


REM Silent install
msiexec /i VeraCrypt-Setup-x64-%softversion%.msi ACCEPTLICENSE=YES INSTALLDESKTOPSHORTCUT="" /qn /L*v "%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT