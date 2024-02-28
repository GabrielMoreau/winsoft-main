
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
ScriptRunner.exe -appvscript LycheeSlicer-%softversion%.exe /S -appvscriptrunnerparameters -wait -timeout=300


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\LycheeSlicer.lnk"          DEL /F /Q "%PUBLIC%\Desktop\LycheeSlicer.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\LycheeSlicer.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\LycheeSlicer.lnk"


ECHO END %date%-%time%
EXIT
