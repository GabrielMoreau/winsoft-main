REM @ECHO OFF

REM
REM   WinMerge
REM

REM Name
SET softname=WinMerge

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
WinMerge-%softversion%-x64-Setup.exe /VERYSILENT /NORESTART /LOG="%logdir%\%softname%-MSI.txt"


EXIT
