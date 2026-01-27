
REM
REM   OpenShot
REM

REM Name
SET softname=OpenShot

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
ScriptRunner.exe -appvscript OpenShot-v%softversion%-x86_64.exe /VERYSILENT /NORESTART /LOG="%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


@ECHO [END] %date%-%time%
EXIT
