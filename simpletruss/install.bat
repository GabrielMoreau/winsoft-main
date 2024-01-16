REM @ECHO OFF

REM
REM   SimpleTruss
REM

REM Name
SET softname=SimpleTruss

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Silent install %softname%
SimpleTrussSetup-%softversion%.exe /VERYSILENT


ECHO END %date%-%time%
EXIT
