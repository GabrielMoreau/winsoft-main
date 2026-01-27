
REM
REM   Optgeo
REM

REM Name
SET softname=Optgeo

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

REM Version parameter (auto update by Makefile)
SET softversion=__VERSION__
SET softexe=installateuroptgeo_%softversion%.exe


@ECHO [INFO] Silent install
ScriptRunner.exe -appvscript "%softexe%" /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300


@ECHO [END] %date%-%time%
EXIT
