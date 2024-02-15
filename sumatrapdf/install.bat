REM @ECHO OFF

REM
REM   SumatraPDF
REM

REM Name
SET softname=SumatraPDF

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
SumatraPDF-%softversion%-64-install.exe -s -all-users -with-filter

ECHO Remove desktop link
IF EXIST "%ALLUSERSPROFILE%\Desktop\SumatraPDF.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\SumatraPDF.lnk"
IF EXIST "%ALLUSERSPROFILE%\Bureau\SumatraPDF.lnk"  DEL /F /Q "%ALLUSERSPROFILE%\Bureau\SumatraPDF.lnk"
IF EXIST "%PUBLIC%\Desktop\SumatraPDF.lnk"          DEL /F /Q "%PUBLIC%\Desktop\SumatraPDF.lnk"


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"

ECHO Execute post-install script
%pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


ECHO END %date%-%time%
EXIT
