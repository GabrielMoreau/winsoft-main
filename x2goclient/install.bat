REM @ECHO OFF

REM
REM   X2GoClient
REM

REM Name
SET softname=X2GoClient

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET softpatch=__PATCH__


REM Silent install
x2goclient-%softversion%-setup.exe /S


ECHO END %date%-%time%
EXIT
