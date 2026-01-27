
REM
REM   Action-Windows11FullUpgrade
REM

REM Name
SET softname=Action-Windows11FullUpgrade

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__


@ECHO [INFO] Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

@ECHO [INFO] Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

@ECHO [INFO] Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET RETURNCODE=0

%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
@ECHO [INFO] Pre-install ErrorLevel Return: %ERRORLEVEL%


IF %ERRORLEVEL% EQU 0 (
  @ECHO [INFO] Silent install %softname% - No ScriptRunner
  Windows11InstallationAssistant-%softversion%.exe /QuietInstall /SkipEULA /NoRestartUI
) ELSE (
  @ECHO [INFO] Hardware not compatible, %softname% will not be installed
)


@ECHO [END] %date%-%time%
EXIT
