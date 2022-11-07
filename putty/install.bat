REM @ECHO OFF

REM
REM   PuTTY
REM

REM Name
SET softname=PuTTY

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=0.70
SET softpatch=2


REM Silent install
msiexec /i putty-64bit-%softversion%-installer.msi /qn /norestart /L*v "%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%

REM IF %ERRORLEVEL% EQU 1603 (
REM   REM 0 or 1603 are good exit code for Putty MSI installer!
REM   EXIT 0
REM )
EXIT
