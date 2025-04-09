
REM
REM   IdeaMaker
REM

REM Name
SET softname=IdeaMaker

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET regkey=ideaMaker


REM Clean reg old uninstall key we push in early version
REM Now, software use register key ideaMaker-App
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ideaMaker"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ideaMaker" /F
)

REM Remove old uninstall.bat
IF EXIST "%ProgramFiles%\Raise3D\ideaMaker\uninstall.bat" RMDIR /S /Q "%ProgramFiles%\Raise3D\ideaMaker"


ECHO Silent install %softname%
ScriptRunner.exe -appvscript install_ideaMaker_%softversion%.exe /S -appvscriptrunnerparameters -wait -timeout=300


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\ideaMaker*.lnk"          DEL /F /Q "%PUBLIC%\Desktop\ideaMaker*.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\ideaMaker*.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\ideaMaker*.lnk"


ECHO END %date%-%time%
EXIT
