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

SET softversion=__VERSION__


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

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\VLC*media*player.lnk"          DEL /F /Q "%PUBLIC%\Desktop\VLC*media*player.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\VLC*media*player.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\VLC*media*player.lnk"

ECHO Remove old key Comments
REG QUERY "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\VLC media player\Comments"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\VLC media player\Comments" /F
)


ECHO END %date%-%time%
EXIT
