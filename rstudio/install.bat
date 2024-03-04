
REM
REM   RStudio
REM

REM Name
SET softname=RStudio

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion1=__VERSION1__
SET softversion2=__VERSION2__


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO Unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Execute pre-install script
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


ECHO Silent install R
ScriptRunner.exe -appvscript R-%softversion2%-win.exe /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300


ECHO Silent install %softname%
ScriptRunner.exe -appvscript RStudio-%softversion1%.exe /S -appvscriptrunnerparameters -wait -timeout=300


ECHO Remove desktop shortcut for R
IF EXIST "%PUBLIC%\Desktop\R*%softversion2%.lnk"          DEL /F /Q "%PUBLIC%\Desktop\R*%softversion2%.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\R*%softversion2%.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\R*%softversion2%.lnk"


ECHO END %date%-%time%
EXIT
