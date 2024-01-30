
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

SET softversion=__VERSION__
SET process=firefox.exe


ECHO Kill the current process
VER | FIND /I "10.0" > NUL
IF %ERRORLEVEL%==0 TASKKILL /T /F /IM %process%

VER | FIND /I "6.1" > NUL
IF %ERRORLEVEL%==0 TASKKILL /T /F /IM %process%


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Execute pre-install script (clean register policies)
%pwrsh% -File ".\pre-install.ps1"


ECHO Silent install %softname%
msiexec /i "Firefox-Setup-%softversion%-esr.msi" INSTALL_MAINTENANCE_SERVICE=false DESKTOP_SHORTCUT=false /q /norestart /L*v "%logdir%\%softname%-MSI.log"


REM voir https://github.com/mozilla/policy-templates/blob/master/README.md
ECHO Push policies
IF EXIST "%ProgramFiles%\Mozilla Firefox" (
  IF NOT EXIST "%ProgramFiles%\Mozilla Firefox\distribution" MKDIR "%ProgramFiles%s\Mozilla Firefox\distribution"
  IF EXIST "%ProgramFiles%\Mozilla Firefox\distribution" COPY /y policies.json "%ProgramFiles%\Mozilla Firefox\distribution\policies.json" > NUL
)

ECHO Execute post-install script
%pwrsh% -File ".\post-install.ps1"


ECHO END %date%-%time%
EXIT
