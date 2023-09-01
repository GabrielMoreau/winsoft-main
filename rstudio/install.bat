REM @ECHO OFF

REM
REM   RStudio
REM

REM Name
SET softname=RStudio

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion1=__VERSION1__
SET softversion2=__VERSION2__
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


ECHO Silent install R
R-%softversion2%-win.exe /VERYSILENT /NORESTART

ECHO Silent install %softname%
RStudio-%softversion1%.exe /S


ECHO Remove desktop shortcut for R
IF EXIST "%PUBLIC%\Desktop\R*%softversion2%.lnk"          DEL /F /Q "%PUBLIC%\Desktop\R*%softversion2%.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\R*%softversion2%.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\R*%softversion2%.lnk"


ECHO END %date%-%time%
EXIT
