REM @ECHO OFF

REM
REM   Skype
REM

REM Name
SET softname=Skype

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL


SET softversion=2.6.11
SET softpatch=1


REM Silent install
Skype-%softversion%.exe /VERYSILENT /NORESTART /SUPPRESSMSGBOXES /DL=1 /LOG="%logdir%\%softname%-MSI.txt"

EXIT
