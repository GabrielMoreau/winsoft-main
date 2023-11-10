REM @ECHO OFF

REM
REM   AnyDesk
REM

REM Name
SET softname=AnyDesk

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET softpatch=__PATCH__


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Execute pre-install script
%pwrsh% -File ".\pre-install.ps1"


ECHO Silent install %softname%
MsiExec.exe /i AnyDesk-%softversion%.msi /qn /L*v "%logdir%\%softname%-MSI.log"
REM AnyDesk-%softversion%.exe --start-with-win --create-shortcuts --remove-first --update-disabled --silent


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\AnyDesk MSI.lnk"          DEL /F /Q "%PUBLIC%\Desktop\AnyDesk MSI.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\AnyDesk MSI.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\AnyDesk MSI.lnk"


ECHO END %date%-%time%
EXIT
