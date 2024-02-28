REM @ECHO OFF

REM
REM   Thunderbird
REM

REM Name
SET softname=Mozilla-Thunderbird

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET process=thunderbird.exe


REM Kill the current process
TASKKILL /T /F /IM %process%


REM Silent install
REM "Thunderbird Setup %softversion%.exe" /MaintenanceService=false /S
ScriptRunner.exe -appvscript MsiExec.exe /i "Thunderbird-Setup-%softversion%.msi" INSTALL_MAINTENANCE_SERVICE=false DESKTOP_SHORTCUT=true /q /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


REM Wait and remove unused service
ping 127.0.0.1 -n 2 > NUL
IF EXIST "c:\Program Files (x86)\Mozilla Thunderbird\uninstall\helper.exe" "c:\Program Files (x86)\Mozilla Thunderbird\uninstall\helper.exe" /S
ping 127.0.0.1 -n 2 > NUL
IF EXIST "c:\Program Files (x86)\Mozilla Maintenance Service\uninstall.exe" "c:\Program Files (x86)\Mozilla Maintenance Service\uninstall.exe" /S


REM Copy policies
IF NOT EXIST "C:\Program Files\Mozilla Thunderbird\distribution" MKDIR "C:\Program Files\Mozilla Thunderbird\distribution"
IF EXIST "C:\Program Files\Mozilla Thunderbird\distribution" COPY /y policies.json "C:\Program Files\Mozilla Thunderbird\distribution\policies.json" > NUL


SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

REM add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

REM unblock
%pwrsh% "Unblock-File -Path .\*.ps1"

REM execute
%pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


ECHO END %date%-%time%
EXIT
