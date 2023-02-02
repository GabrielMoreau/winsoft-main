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

SET softversion=91.5.1
SET softpatch=1

SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe


REM Create folder
IF NOT EXIST "%ProgramData%\OCS Inventory NG" (
  MKDIR "%ProgramData%\OCS Inventory NG"
)
IF NOT EXIST "%ProgramData%\OCS Inventory NG\DelayedInstall" (
  MKDIR "%ProgramData%\OCS Inventory NG\DelayedInstall"
)

REM Copy installation files
COPY /B /Y "post-install.bat" "%ProgramData%\OCS Inventory NG\DelayedInstall\post-install.bat"
COPY /B /Y "OCS-Windows-Agent-Setup-%softversion%-x64.exe" "%ProgramData%\OCS Inventory NG\DelayedInstall\OCS-Windows-Agent-Setup-%softversion%-x64.exe"

REM add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

REM unblock
%pwrsh% "Unblock-File -Path .\set-task.ps1"

REM execute
%pwrsh% -File ".\set-task.ps1"


ECHO END %date%-%time%
EXIT
