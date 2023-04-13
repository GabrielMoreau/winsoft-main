REM @ECHO OFF

REM
REM   VSCode
REM

REM Name
SET softname=VSCode

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
VSCodeSetup-x64-%softversion%.exe /VERYSILENT /NORESTART /MERGETASKS=!runcode /LOG="%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
