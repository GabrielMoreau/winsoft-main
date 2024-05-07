
REM
REM   Autopsy
REM

REM Name
SET softname=Autopsy

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
ScriptRunner.exe -appvscript MsiExec.exe /i "autopsy-%softversion%-64bit.msi" /qn /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=900


REM ECHO Remove desktop shortcut
REM IF EXIST "%PUBLIC%\Desktop\Autopsy.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Autopsy.lnk"
REM IF EXIST "%ALLUSERSPROFILE%\Desktop\Autopsy.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Autopsy.lnk"


ECHO END %date%-%time%
EXIT
