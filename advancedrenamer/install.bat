
REM
REM   Advanced-Renamer
REM

REM Name
SET softname=Advanced-Renamer

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
ScriptRunner.exe -appvscript advanced_renamer_setup_%softversion%.exe /SP- /VERYSILENT /SUPRESSMSGBOXES /NORESTART -appvscriptrunnerparameters -wait -timeout=300


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Advanced-Renamer.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Advanced-Renamer.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Advanced-Renamer.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Advanced-Renamer.lnk"


ECHO END %date%-%time%
EXIT
