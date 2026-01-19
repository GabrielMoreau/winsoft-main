
REM
REM   Action-RebootIfPending
REM

REM Name
SET softname=Action-RebootIfPending

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET RETURNCODE=0


REM https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/manage-bde-status
ECHO Bitlocker state
manage-bde -status %SystemDrive%


ECHO Execute pre-install script
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
SET PreInstallCode=%ERRORLEVEL%

IF %PreInstallCode% NEQ 0 (
  REM https://techwiser.com/ways-to-disable-and-suspend-bitlocker-on-windows-10-11/
  REM https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/manage-bde-protectors
  ECHO Suspend bitlocker
  manage-bde -protectors -disable %SystemDrive%

  ECHO Force Reboot Computer
  shutdown /r /t 300 /c "Force Reboot in 5 min by __IT_TEAM__"

  ECHO Bitlocker state after sending reboot trigger
  manage-bde -status %SystemDrive%
)


ECHO END %date%-%time%
EXIT %PreInstallCode%
