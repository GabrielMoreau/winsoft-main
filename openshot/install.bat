REM @ECHO OFF

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

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Silent install %softname%
OpenShot-v%softversion%-x86_64.exe /VERYSILENT /NORESTART /LOG="%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
