REM @ECHO OFF

REM
REM   Firefox
REM

REM Name
SET softname=Mozilla-Firefox

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=91.5.1
SET softpatch=1
SET process=firefox.exe


ECHO Kill the current process
VER | FIND /I "10.0" > NUL
IF %ERRORLEVEL%==0 TASKKILL /T /F /IM %process%

VER | FIND /I "6.1" > NUL
IF %ERRORLEVEL%==0 TASKKILL /T /F /IM %process%


ECHO Silent install %softname%
msiexec /i "Firefox-Setup-%softversion%-esr.msi" INSTALL_MAINTENANCE_SERVICE=false /q


REM voir https://github.com/mozilla/policy-templates/blob/master/README.md
IF EXIST "C:\Program Files\Mozilla Firefox" (
  IF NOT EXIST "C:\Program Files\Mozilla Firefox\distribution" MKDIR "C:\Program Files\Mozilla Firefox\distribution"
  IF EXIST "C:\Program Files\Mozilla Firefox\distribution" COPY /y policies.json "C:\Program Files\Mozilla Firefox\distribution\policies.json" > NUL
)


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"

ECHO Execute post-install script
%pwrsh% -File ".\post-install.ps1"


ECHO END %date%-%time%
EXIT
