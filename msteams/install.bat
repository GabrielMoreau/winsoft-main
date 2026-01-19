
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

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__

ECHO Fix PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"

ECHO Execute pre-install script
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


REM ECHO Prepare install %softname%
REM ScriptRunner.exe -appvscript "teamsbootstrapper.exe" -p -o "teams-%softversion%-x64.msix" -appvscriptrunnerparameters -wait -timeout=300


IF %ERRORLEVEL% NEQ 0 (
    ECHO Silent install %softname%
    ScriptRunner.exe -appvscript DISM /Online /Add-ProvisionedAppxPackage /PackagePath:"teams-%softversion%-x64.msix" /SkipLicense -appvscriptrunnerparameters -wait -timeout=300
)


ECHO Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)


ECHO END %date%-%time%
IF %ERRORLEVEL% EQU 0 (
    ECHO %softname% is installed
) ELSE (
    ECHO %softname% is not installed!
)
EXIT %ERRORLEVEL%
