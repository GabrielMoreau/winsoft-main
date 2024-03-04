
REM
REM   VisIt
REM

REM Name
SET softname=VisIt

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
ScriptRunner.exe -appvscript visit%softversion%_x64.exe /S -appvscriptrunnerparameters -wait -timeout=300


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\VisIt*.lnk"          DEL /F /Q "%PUBLIC%\Desktop\VisIt*.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\VisIt*.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\VisIt*.lnk"


ECHO END %date%-%time%
EXIT
