REM @ECHO OFF

REM
REM   ArduinoIDE
REM

REM Name
SET softname=ArduinoIDE

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
msiexec /i "arduino-ide_%softversion%_Windows_64bit.msi" ALLUSERS=1 /qn /L*v "%logdir%\%softname%-MSI.log"


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Arduino*IDE.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Arduino*IDE.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Arduino*IDE.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Arduino*IDE.lnk"


ECHO END %date%-%time%
EXIT
