REM @ECHO OFF

REM
REM   Inkscape
REM

REM Name
SET softname=Inkscape

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


ECHO Silent install %softname%
ScriptRunner.exe -appvscript MsiExec.exe /i "inkscape-%softversion%-x64.msi" ALLUSERS=1 /qn /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


ECHO Execute post-install script
%pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Inkscape.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Inkscape.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Inkscape.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Inkscape.lnk"


ECHO END %date%-%time%
EXIT
