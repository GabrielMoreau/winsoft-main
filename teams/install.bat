REM @ECHO OFF

REM
REM   Microsoft Teams
REM

REM Name
SET softname=Teams

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=1.4.00.3321
SET softpatch=1


ECHO Silent install
msiexec /i "Teams_%softversion%_windows_x64.msi" OPTIONS="noAutoStart=true" ALLUSERS=1 /qn

ECHO END %date%-%time%
EXIT
