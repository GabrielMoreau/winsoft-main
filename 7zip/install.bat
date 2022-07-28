REM @ECHO OFF

REM
REM   7-Zip
REM

REM Name
SET softname=7-Zip

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=18.05
SET softversionshort=1805
SET softpatch=1
SET process=7z.exe


REM Kill running process
taskkill /T /F /IM %process%


REM Silent install
msiexec /i "7z%softversionshort%-x64.msi" /quiet


ECHO END %date%-%time%
EXIT
