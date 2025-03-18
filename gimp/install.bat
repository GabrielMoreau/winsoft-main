
REM
REM   Gimp
REM

REM Name
SET softname=Gimp

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
ScriptRunner.exe -appvscript gimp-%softversion%-setup.exe /VERYSILENT /NORESTART /ALLUSERS /LOG="%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=600


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\GIMP *.lnk"          DEL /F /Q "%PUBLIC%\Desktop\GIMP *.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\GIMP *.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\GIMP *.lnk"


ECHO END %date%-%time%
EXIT
