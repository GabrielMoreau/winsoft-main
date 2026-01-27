
REM
REM   Defraggler
REM

REM Name
SET softname=Defraggler

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
ScriptRunner.exe -appvscript dfsetup%softversion%.exe /S -appvscriptrunnerparameters -wait -timeout=300


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Defraggler.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Defraggler.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Defraggler.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Defraggler.lnk"


@ECHO [END] %date%-%time%
EXIT
