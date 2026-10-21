
REM
REM   IdeaMaker
REM

REM Name
SET "softname=IdeaMaker"

SET "logdir=__LOGDIR__"
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET "softversion=__VERSION__"
SET "regkey=ideaMaker"


@ECHO [INFO] Search PowerShell
SET "pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe"
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET "pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe"

@ECHO [INFO] Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

@ECHO [INFO] Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET "RETURNCODE=0"


@ECHO [INFO] Execute pre-install script
IF EXIST ".\pre-install.ps1" %pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"


@ECHO [INFO] Clean reg old uninstall key we push in early version
@ECHO [INFO] Now, software use register key ideaMaker-App
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ideaMaker"
IF "%ERRORLEVEL%"=="0" (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ideaMaker" /F
)


@ECHO [INFO] Remove old uninstall.bat
IF EXIST "%ProgramFiles%\Raise3D\ideaMaker\uninstall.bat" RMDIR /S /Q "%ProgramFiles%\Raise3D\ideaMaker"


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript install_ideaMaker_%softversion%.exe /S -appvscriptrunnerparameters -wait -timeout=300
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\ideaMaker*.lnk"          DEL /F /Q "%PUBLIC%\Desktop\ideaMaker*.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\ideaMaker*.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\ideaMaker*.lnk"


:POSTINSTALL
@ECHO [INFO] Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"


:END
@ECHO [END] %date%-%time%
EXIT %RETURNCODE%
