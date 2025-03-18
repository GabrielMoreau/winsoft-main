
REM
REM   OnlyOffice
REM

REM Name
SET softname=OnlyOffice

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
ScriptRunner.exe -appvscript MsiExec.exe /i "DesktopEditors-%softversion%-x64.msi" /qn /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


REM ECHO Remove desktop shortcut
REM IF EXIST "%PUBLIC%\Desktop\OnlyOffice.lnk"          DEL /F /Q "%PUBLIC%\Desktop\OnlyOffice.lnk"
REM IF EXIST "%ALLUSERSPROFILE%\Desktop\OnlyOffice.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\OnlyOffice.lnk"


ECHO END %date%-%time%
EXIT
