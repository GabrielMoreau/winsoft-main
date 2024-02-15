REM @ECHO OFF

REM
REM   Windows11Update
REM

REM Name
SET softname=Windows11Update

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"

%pwrsh% -File ".\pre-install.ps1"

ECHO errorlevel %ERRORLEVEL%

IF %ERRORLEVEL% EQU 0 (
  ECHO Silent install %softname%
  Windows11InstallationAssistant-%softversion%.exe /QuietInstall /SkipEULA /NoRestartUI
  )
ELSE (
  ECHO %softname% not installed
  )

ECHO END %date%-%time%
EXIT
