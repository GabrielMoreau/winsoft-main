
REM
REM   OCSInventory-Agent
REM

REM Name
SET softname=OCSInventory-Agent

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


@ECHO [INFO] Execute pre-install script
IF EXIST ".\pre-install.ps1" %pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


@ECHO [INFO] Create and clean folder
IF EXIST "%ProgramData%\OCS Inventory NG\DelayedInstall" (
  RMDIR /S /Q "%ProgramData%\OCS Inventory NG\DelayedInstall"
)
IF NOT EXIST "%ProgramData%\OCS Inventory NG" (
  MKDIR "%ProgramData%\OCS Inventory NG"
)
IF NOT EXIST "%ProgramData%\OCS Inventory NG\DelayedInstall" (
  MKDIR "%ProgramData%\OCS Inventory NG\DelayedInstall"
)

@ECHO [INFO] Silent install %softname%
COPY /A /Y "install-outofservice.bat" "%ProgramData%\OCS Inventory NG\DelayedInstall\install-outofservice.bat"
COPY /B /Y "OCS-Windows-Agent-Setup-%softversion%-x64.exe" "%ProgramData%\OCS Inventory NG\DelayedInstall\OCS-Windows-Agent-Setup-%softversion%-x64.exe"
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


:POSTINSTALL
@ECHO [INFO] Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


:END
@ECHO [END] %date%-%time%
EXIT %RETURNCODE%
