REM @ECHO OFF

REM
REM   OBS-Studio
REM

REM Name
SET softname=OBS-Studio

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

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Execute pre-install script
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1

ECHO Silent install CPP Redistributable DLL
VC_redist.x64.exe /install /quiet /norestart

ECHO Silent install %softname%
OBS-Studio-%softversion%-Full-Installer-x64.exe /S

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\OBS*Studio.lnk"          DEL /F /Q "%PUBLIC%\Desktop\OBS*Studio.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\OBS*Studio.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\OBS*Studio.lnk"


ECHO Disable Auto Updates
REM Write for system in C:\Windows\System32\config\systemprofile\AppData\Roaming\obs-studio
REM Write for user in   C:\Users\toto-user\AppData\Roaming\obs-studio
REM So no work at global configuration...
REM COPY /A /Y "global.ini" "%AppData%\obs-studio\global.ini"
REM Just copy in install folder, user have to copy it in their app data folder
COPY /A /Y "global.ini" "%ProgramFiles%\obs-studio\global.ini"


ECHO END %date%-%time%
EXIT
