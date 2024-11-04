
REM
REM   CloudCompare
REM

REM Name
SET softname=CloudCompare

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
ScriptRunner.exe -appvscript CloudCompare_v%softversion%_setup_x64.exe /SP- /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\CloudCompare.lnk"          DEL /F /Q "%PUBLIC%\Desktop\CloudCompare.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\CloudCompare.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\CloudCompare.lnk"


ECHO END %date%-%time%
EXIT
