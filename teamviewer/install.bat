
REM
REM   TeamViewer
REM

REM Name
SET softname=TeamViewer

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
ScriptRunner.exe -appvscript TeamViewer-%softversion%-Setup-x64.exe /S -appvscriptrunnerparameters -wait -timeout=300


ECHO Disable auto update
REG ADD "HKLM\SOFTWARE\WOW6432Node\TeamViewer" /v AutoUpdateMode /t REG_DWORD /d 3 /f
REG ADD "HKLM\SOFTWARE\WOW6432Node\TeamViewer" /v UpdateCheckInterval /t REG_DWORD /d 2 /f
cmd /c "net stop "TeamViewer" && net start "TeamViewer""


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\%softname%.lnk"          DEL /F /Q "%PUBLIC%\Desktop\%softname%.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\%softname%.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\%softname%.lnk"


ECHO END %date%-%time%
EXIT
