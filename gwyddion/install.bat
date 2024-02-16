REM @ECHO OFF

REM
REM   Gwyddion
REM

REM Name
SET softname=Gwyddion

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
Gwyddion-%softversion%-x64.exe /S


ECHO END %date%-%time%
EXIT
