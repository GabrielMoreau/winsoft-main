
REM
REM   VLC
REM

REM Name
SET softname=VideoLAN-VLC-Media-Player

SET logdir=__LOGDIR__
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

ECHO Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET RETURNCODE=0


ECHO Execute pre-install script
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


ECHO Silent install %softname%
ScriptRunner.exe -appvscript "vlc-%softversion%-win64.exe" /S /NCRC -appvscriptrunnerparameters -wait -timeout=300


ECHO Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\VLC*media*player.lnk"          DEL /F /Q "%PUBLIC%\Desktop\VLC*media*player.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\VLC*media*player.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\VLC*media*player.lnk"

ECHO Remove old key Comments
REG QUERY "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\VLC media player" /v "Comments"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\VLC media player" /v "Comments" /F
) ELSE (
  ECHO Reset ERRORLEVEL variable with the VER command
  ECHO Good code script must finish with EXIT 0
  VER
)


ECHO END %date%-%time%
EXIT
