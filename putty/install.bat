REM @ECHO OFF

REM Hide the Window
REM "cmdow.exe" @ /hid

REM
REM   PuTTY
REM

REM Name
SET softname=PuTTY

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=0.70
SET softpatch=2


REM Silent install
msiexec /i putty-64bit-%softversion%-installer.msi /q


ECHO END %date%-%time%
EXIT
