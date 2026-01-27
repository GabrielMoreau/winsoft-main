
REM
REM   OmnissaHorizon
REM

REM Name
SET softname=OmnissaHorizon

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSIONLONG__


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript Omnissa-Horizon-Client-%softversion%.exe /silent /install /norestart /log "%logdir%\%softname%-MSI.log" DESKTOP_SHORTCUT=0 -appvscriptrunnerparameters -wait -timeout=300


@ECHO [END] %date%-%time%
EXIT
