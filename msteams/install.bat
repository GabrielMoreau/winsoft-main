
REM
REM   Microsoft Teams
REM

REM Name
SET softname=MSTeams

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


IF %ERRORLEVEL% NEQ 0 (
    @ECHO [INFO] Silent install %softname%
    ScriptRunner.exe -appvscript DISM /Online /Add-ProvisionedAppxPackage /PackagePath:"teams-%softversion%-x64.msix" /SkipLicense -appvscriptrunnerparameters -wait -timeout=300
)
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
IF %RETURNCODE% EQU 0 (
    @ECHO [INFO] %softname% is installed
) ELSE (
    @ECHO [WARN] %softname% is not installed!
)
EXIT %RETURNCODE%
