
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

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Execute pre-install script
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


ECHO Bitlocker state before
manage-bde -status %SystemDrive%

IF %ERRORLEVEL% EQU 0 (
  REM https://techwiser.com/ways-to-disable-and-suspend-bitlocker-on-windows-10-11/
  ECHO Suspend bitlocker
  manage-bde -protectors -Disable %SystemDrive%

  ECHO Force Reboot Computer
  shutdown /r /t 300 /c "Force Reboot in 5 min by __IT_TEAM__"
)

ECHO Bitlocker state before
manage-bde -status %SystemDrive%


ECHO END %date%-%time%
EXIT
