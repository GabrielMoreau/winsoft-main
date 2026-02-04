
REM
REM   RocketChat
REM

REM Name
SET softname=RocketChat

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__
SET process=Rocket.Chat.exe


@ECHO [INFO] Kill the current process
TASKKILL /T /F /IM %process%


@ECHO [INFO] Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

@ECHO [INFO] Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

@ECHO [INFO] Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET RETURNCODE=0


@ECHO [INFO] Execute pre-install script
IF EXIST ".\pre-install.ps1" %pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript MsiExec.exe /q /i "rocketchat-%softversion%-win-x64.msi" ALLUSERS=1 /l*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


:POSTINSTALL
@ECHO [INFO] Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


@ECHO [INFO] Push policies
IF EXIST "C:\Program Files\rocketchat\" (
  IF NOT EXIST "%ProgramFiles%\rocketchat\resources" MKDIR "%ProgramFiles%\rocketchat\resources"
  IF EXIST     "%ProgramFiles%\rocketchat\resources" COPY /A /Y servers.json "%ProgramFiles%\rocketchat\resources\servers.json"
)


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Rocket.Chat.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Rocket.Chat.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Rocket.Chat.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Rocket.Chat.lnk"


:END
@ECHO [END] %date%-%time%
EXIT %RETURNCODE%
