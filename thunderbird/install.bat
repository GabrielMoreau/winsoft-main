
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


ECHO Kill the current process
TASKKILL /T /F /IM %process%


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Silent install %softname%
REM TASKBAR_SHORTCUT=false DESKTOP_SHORTCUT=false INSTALL_MAINTENANCE_SERVICE=false
ScriptRunner.exe -appvscript MsiExec.exe /i "Thunderbird-Setup-%softversion%.msi" INSTALL_MAINTENANCE_SERVICE=false DESKTOP_SHORTCUT=true /q /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
SET RETURNCODE=%ERRORLEVEL%

ECHO Wait and remove unused service
ping 127.0.0.1 -n 2 > NUL
IF EXIST "c:\Program Files (x86)\Mozilla Thunderbird\uninstall\helper.exe" "c:\Program Files (x86)\Mozilla Thunderbird\uninstall\helper.exe" /S
ping 127.0.0.1 -n 2 > NUL
IF EXIST "c:\Program Files (x86)\Mozilla Maintenance Service\uninstall.exe" "c:\Program Files (x86)\Mozilla Maintenance Service\uninstall.exe" /S


REM voir https://github.com/mozilla/policy-templates/blob/master/README.md
ECHO Push policies
IF EXIST "%ProgramFiles%\Mozilla Thunderbird" (
  IF NOT EXIST "C:\Program Files\Mozilla Thunderbird\distribution" MKDIR "C:\Program Files\Mozilla Thunderbird\distribution"
  IF EXIST "C:\Program Files\Mozilla Thunderbird\distribution" COPY /y policies.json "C:\Program Files\Mozilla Thunderbird\distribution\policies.json" > NUL
)


:POSTINSTALL
ECHO Execute post-install script
%pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


:END
ECHO END %date%-%time%
EXIT %RETURNCODE%
