
REM
REM   Kopia
REM

REM Name
SET softname=Kopia

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Kill running process
TASKKILL /IM KopiaUI.exe /IM Kopia.exe /F


ECHO Silent install %softname%
ScriptRunner.exe -appvscript KopiaUI-Setup-%softversion%.exe /S /allusers /disableAutoUpdates -appvscriptrunnerparameters -wait -timeout=300


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\KopiaUI.lnk"          DEL /F /Q "%PUBLIC%\Desktop\KopiaUI.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\KopiaUI.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\KopiaUI.lnk"


ECHO END %date%-%time%
EXIT
