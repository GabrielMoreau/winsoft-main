REM @ECHO OFF

REM
REM   Windows11Update
REM

REM Name
SET softname=Windows11Update

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
Windows11InstallationAssistant-%softversion%.exe /QuietInstall /SkipEULA /NoRestartUI 


ECHO END %date%-%time%
EXIT
