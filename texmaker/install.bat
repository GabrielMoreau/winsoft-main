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
ScriptRunner.exe -appvscript MsiExec.exe /i "Texmaker_%softversion%_Win_x64.msi"  /q -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
