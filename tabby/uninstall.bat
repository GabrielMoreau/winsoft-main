
REM
REM   Uninstall-Tabby
REM

REM Name
SET softname=Uninstall-Tabby

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__


@ECHO [INFO] Silent uninstall %softname%
IF EXIST "%ProgramFiles%\Tabby\Uninstall Tabby.exe" (
  ScriptRunner.exe -appvscript "%ProgramFiles%\Tabby\Uninstall Tabby.exe" /S /ALLUSERS -appvscriptrunnerparameters -wait -timeout=300
)


@ECHO [END] %date%-%time%
EXIT
