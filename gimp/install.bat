REM @ECHO OFF

REM
REM   Gimp
REM

REM Name
SET softname=Gimp

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
gimp-%softversion%-setup.exe /VERYSILENT /NORESTART /ALLUSERS /LOG="%logdir%\%softname%-MSI.txt"


EXIT
