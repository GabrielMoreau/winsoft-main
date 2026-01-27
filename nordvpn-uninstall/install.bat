
REM
REM   Uninstall-NordVPN
REM

REM Name
SET softname=Uninstall-NordVPN

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
IF EXIST "C:\Program Files\NordVPN\unins000.exe" (
ScriptRunner.exe -appvscript "C:\Program Files\NordVPN\unins000.exe" /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300
)


@ECHO [END] %date%-%time%
EXIT
