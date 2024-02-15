REM @ECHO OFF

REM
REM   OCSInventory-Agent
REM

REM Name
SET softname=OCSInventory-Agent

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


REM Create and clean folder
IF EXIST "%ProgramData%\OCS Inventory NG\DelayedInstall" (
  RMDIR /S /Q "%ProgramData%\OCS Inventory NG\DelayedInstall"
)
IF NOT EXIST "%ProgramData%\OCS Inventory NG" (
  MKDIR "%ProgramData%\OCS Inventory NG"
)
IF NOT EXIST "%ProgramData%\OCS Inventory NG\DelayedInstall" (
  MKDIR "%ProgramData%\OCS Inventory NG\DelayedInstall"
)

REM Copy installation files
COPY /A /Y "install-outofservice.bat" "%ProgramData%\OCS Inventory NG\DelayedInstall\install-outofservice.bat"
COPY /B /Y "OCS-Windows-Agent-Setup-%softversion%-x64.exe" "%ProgramData%\OCS Inventory NG\DelayedInstall\OCS-Windows-Agent-Setup-%softversion%-x64.exe"


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
