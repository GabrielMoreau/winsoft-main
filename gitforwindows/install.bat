REM @ECHO OFF

REM
REM   GitForWindows
REM

REM Name
SET softname=GitForWindows

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL


SET softversion=2.18.0
SET softpatch=1

REM Silent install
Git-%softversion%-64-bit.exe /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS

EXIT
