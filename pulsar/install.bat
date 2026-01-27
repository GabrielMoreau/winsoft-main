
REM
REM   Pulsar-Edit
REM

REM Name
SET softname=Pulsar-Edit

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
ScriptRunner.exe -appvscript Windows.Pulsar.Setup.%softversion%.exe /S /ALLUSERS -appvscriptrunnerparameters -wait -timeout=300


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Pulsar.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Pulsar.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Pulsar.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Pulsar.lnk"


@ECHO [END] %date%-%time%
EXIT
