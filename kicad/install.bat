
REM
REM   KiCad
REM

SET softname=KiCad

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
ScriptRunner.exe -appvscript kicad-%softversion%-x86_64.exe /S /allusers -appvscriptrunnerparameters -wait -timeout=900


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\KiCad *.lnk"          DEL /F /Q "%PUBLIC%\Desktop\KiCad *.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\KiCad *.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\KiCad *.lnk"


@ECHO [END] %date%-%time%
EXIT
