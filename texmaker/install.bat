REM @ECHO OFF

REM
REM   TexMaker
REM

REM Name
SET softname=TexMaker

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__


ECHO Silent install
msiexec /i "Texmaker_%softversion%_Win_x64.msi"  /q


ECHO END %date%-%time%
EXIT
