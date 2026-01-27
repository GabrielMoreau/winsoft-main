
REM
REM   Recuva
REM

REM Name
SET softname=Recuva

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
ScriptRunner.exe -appvscript rcsetup%softversion%.exe /S -appvscriptrunnerparameters -wait -timeout=300


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Recuva.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Recuva.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Recuva.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Recuva.lnk"


@ECHO [END] %date%-%time%
EXIT
