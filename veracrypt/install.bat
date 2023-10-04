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

SET softversion=__VERSION__
SET softpatch=__PATCH__


REM Silent install
msiexec /i VeraCrypt-Setup-x64-%softversion%.msi ACCEPTLICENSE=YES INSTALLDESKTOPSHORTCUT="" /qn /norestart /L*v "%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%

IF %ERRORLEVEL% EQU 1603 (
  ECHO 0 or 1603 are good exit code for %softname% installer!
  EXIT 0
)
EXIT
