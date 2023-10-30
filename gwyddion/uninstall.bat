
REM
REM   Uninstall Gwyddion
REM

REM Name
SET softname=Gwyddion

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\Uninstall-%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Execute uninstall script
%pwrsh% -File ".\uninstall.ps1"


ECHO END %date%-%time%
EXIT
