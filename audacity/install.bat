REM @ECHO OFF

REM
REM   Audacity
REM

REM Name
SET softname=Audacity

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL

SET softversion=91.5.1
SET softpatch=1

REM Silent install
audacity-win-%softversion%-64bit.exe /S


EXIT
