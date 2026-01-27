
REM
REM   SimpleTruss
REM

REM Name
SET softname=SimpleTruss

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript SimpleTrussSetup-%softversion%.exe /VERYSILENT -appvscriptrunnerparameters -wait -timeout=300


@ECHO [END] %date%-%time%
EXIT
