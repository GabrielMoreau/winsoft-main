REM @ECHO OFF

REM
REM   Ultracopier
REM

REM Name
SET softname=Ultracopier

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=91.5.1
SET softpatch=1


REM Silent install
ultracopier-windows-x86_64-%softversion%-setup.exe /S


ECHO END %date%-%time%
EXIT
