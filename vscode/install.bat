REM @ECHO OFF

REM
REM   VSCode
REM

REM Name
SET softname=VSCode

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
VSCodeSetup-x64-%softversion%.exe /VERYSILENT /NORESTART /MERGETASKS=!runcode /LOG="%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
