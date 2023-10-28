REM @ECHO OFF

REM
REM   Tabby
REM

REM Name
SET softname=Tabby

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


ECHO Silent install %softname%
tabby-%softversion%-setup-x64.exe /S /ALLUSERS


ECHO END %date%-%time%
EXIT
