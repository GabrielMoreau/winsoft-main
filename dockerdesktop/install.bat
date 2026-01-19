
REM
REM   DockerDesktop
REM

REM Name
SET softname=DockerDesktop

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
ScriptRunner.exe -appvscript "DockerDesktopInstaller-%softversion%.exe" install --quiet --accept-license -appvscriptrunnerparameters -wait -timeout=300


ECHO Remove desktop shortcut
REM IF EXIST "%PUBLIC%\Desktop\DockerDesktop.lnk"          DEL /F /Q "%PUBLIC%\Desktop\DockerDesktop.lnk"
REM IF EXIST "%ALLUSERSPROFILE%\Desktop\DockerDesktop.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\DockerDesktop.lnk"


ECHO END %date%-%time%
EXIT
