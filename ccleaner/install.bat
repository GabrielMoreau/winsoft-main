
REM
REM   CCleaner
REM

REM Name
SET softname=CCleaner

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__
SET process=ccleaner.exe


ECHO Kill running process
TASKKILL /T /F /IM %process%


ECHO Silent install %softname%
ScriptRunner.exe -appvscript ccsetup-%softversion%.exe /S /L=1036 -appvscriptrunnerparameters -wait -timeout=300


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
