
REM
REM   Skype
REM

REM Name
SET softname=Skype

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
ScriptRunner.exe -appvscript Skype-%softversion%.exe /VERYSILENT /NORESTART /SUPPRESSMSGBOXES /DL=1 /LOG="%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\%softname%.lnk"          DEL /F /Q "%PUBLIC%\Desktop\%softname%.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\%softname%.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\%softname%.lnk"


ECHO END %date%-%time%
EXIT
