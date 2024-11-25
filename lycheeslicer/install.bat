
REM
REM   LycheeSlicer
REM

REM Name
SET softname=LycheeSlicer

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
ScriptRunner.exe -appvscript LycheeSlicer-%softversion%.exe /allusers /S -appvscriptrunnerparameters -wait -timeout=300


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\LycheeSlicer.lnk"          DEL /F /Q "%PUBLIC%\Desktop\LycheeSlicer.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\LycheeSlicer.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\LycheeSlicer.lnk"


ECHO END %date%-%time%
EXIT
