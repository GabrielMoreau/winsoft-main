
REM
REM   Firefox
REM

REM Name
SET softname=Mozilla-Firefox

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET process=firefox.exe


ECHO Kill the current process
TASKKILL /T /F /IM %process%


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Execute pre-install script (clean register policies)
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


ECHO Silent install %softname%
ScriptRunner.exe -appvscript MsiExec.exe /i "Firefox-Setup-%softversion%-esr.msi" INSTALL_MAINTENANCE_SERVICE=false /q /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
SET RETURNCODE=%ERRORLEVEL%


REM voir https://github.com/mozilla/policy-templates/blob/master/README.md
ECHO Push policies
IF EXIST "%ProgramFiles%\Mozilla Firefox" (
  IF NOT EXIST "%ProgramFiles%\Mozilla Firefox\distribution" MKDIR "%ProgramFiles%\Mozilla Firefox\distribution"
  IF EXIST "%ProgramFiles%\Mozilla Firefox\distribution" COPY /y policies.json "%ProgramFiles%\Mozilla Firefox\distribution\policies.json" > NUL
)


:POSTINSTALL
ECHO Execute post-install script
%pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


:END
ECHO END %date%-%time%
EXIT %RETURNCODE%
