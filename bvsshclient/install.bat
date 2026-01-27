
REM
REM   BvSshClient
REM

REM Name
SET softname=BvSshClient

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

@ECHO [INFO] Unblock PS1
%pwrsh% "Unblock-File -Path .\*.ps1"


@ECHO [INFO] Execute pre-install script
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript BvSshClient-Inst-%softversion%.exe -acceptEULA -noDesktopIcon=y -autoUpdates=0 -appvscriptrunnerparameters -wait -timeout=300


@ECHO [END] %date%-%time%

IF %ERRORLEVEL% EQU 1 (
  REM 0 or 1 are good exit code for this installer!
  EXIT 0
)
EXIT
