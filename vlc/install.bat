REM @ECHO OFF

REM
REM   VLC
REM

REM Name
SET softname=VideoLAN-VLC-Media-Player

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=3.0.13
SET softpatch=1


ECHO Silent install %softname%
"vlc-%softversion%-win64.exe" /S /NCRC


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
