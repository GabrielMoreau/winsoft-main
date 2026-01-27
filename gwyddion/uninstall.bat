
REM
REM   Uninstall Gwyddion
REM

REM Name
SET softname=Gwyddion

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\Uninstall-%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%


@ECHO [INFO] Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

@ECHO [INFO] Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

@ECHO [INFO] Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET RETURNCODE=0


@ECHO [INFO] Execute uninstall script
%pwrsh% -File ".\uninstall.ps1" 1> "%logdir%\Uninstall-%softname%-PS1.log" 2>&1


@ECHO [END] %date%-%time%
EXIT
