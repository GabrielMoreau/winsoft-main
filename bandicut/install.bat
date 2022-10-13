REM @ECHO OFF

REM
REM   Bandicut
REM

REM Name
SET softname=Bandicut

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
bandicut-setup-%softversion%.exe /S


ECHO END %date%-%time%
EXIT
