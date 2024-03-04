
REM
REM   KiCad
REM

SET softname=KiCad

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
ScriptRunner.exe -appvscript kicad-%softversion%-x86_64.exe /S -appvscriptrunnerparameters -wait -timeout=300


REM ECHO Remove desktop shortcut
REM IF EXIST "%PUBLIC%\Desktop\KiCad.lnk"          DEL /F /Q "%PUBLIC%\Desktop\KiCad.lnk"
REM IF EXIST "%ALLUSERSPROFILE%\Desktop\KiCad.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\KiCad.lnk"


ECHO END %date%-%time%
EXIT
