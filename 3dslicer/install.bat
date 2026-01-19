
REM
REM   3DSlicer
REM

REM Name
SET softname=3DSlicer

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
ScriptRunner.exe -appvscript Slicer-%softversion%-win-amd64.exe /S /D=%ProgramData%\Slicer.org -appvscriptrunnerparameters -wait -timeout=300


ECHO Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)


REM ECHO Remove desktop shortcut
REM IF EXIST "%PUBLIC%\Desktop\3DSlicer.lnk"          DEL /F /Q "%PUBLIC%\Desktop\3DSlicer.lnk"
REM IF EXIST "%ALLUSERSPROFILE%\Desktop\3DSlicer.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\3DSlicer.lnk"


ECHO END %date%-%time%
EXIT
