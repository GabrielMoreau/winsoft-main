
REM
REM   LycheeSlicer
REM

REM Name
SET softname=LycheeSlicer

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
ScriptRunner.exe -appvscript LycheeSlicer-%softversion%.exe /S -appvscriptrunnerparameters -wait -timeout=120


ECHO END %date%-%time%
EXIT
