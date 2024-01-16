REM @ECHO OFF

REM
REM   MSEdge
REM

REM Name
SET softname=MSEdge

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Execute pre-install script
%pwrsh% -File ".\pre-install.ps1"


ECHO Silent install %softname%
msiexec /i MicrosoftEdgeEnterpriseX64-%softversion%.msi DONOTCREATEDESKTOPSHORTCUT=true DONOTCREATETASKBARSHORTCUT=true /qn /L*v "%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%

IF %ERRORLEVEL% EQU 1603 (
  ECHO 0 or 1603 are good exit code for %softname% installer!
  EXIT 0
)
EXIT
