REM @ECHO OFF
REM Hide the Window

REM "cmdow.exe" @ /hid

REM
REM   X2GoClient
REM

REM Name
SET softname=X2GoClient

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
x2goclient-%softversion%-setup.exe /S


EXIT