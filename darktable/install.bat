
REM
REM   Darktable
REM

REM Name
SET softname=Darktable

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
ScriptRunner.exe -appvscript darktable-%softversion%-win64.exe /S -appvscriptrunnerparameters -wait -timeout=300


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Darktable.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Darktable.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Darktable.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Darktable.lnk"


ECHO END %date%-%time%
EXIT
