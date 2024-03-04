
REM
REM   VMwareHorizon
REM

REM Name
SET softname=VMwareHorizon

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSIONLONG__


ECHO Silent install %softname%
ScriptRunner.exe -appvscript VMware-Horizon-Client-%softversion%.exe /silent /install /norestart /log "%logdir%\%softname%-MSI.log" DESKTOP_SHORTCUT=0 -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
