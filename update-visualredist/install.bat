
REM
REM   Update-VisualCPPRedistributable
REM

REM Name
SET softname=Update-VisualCPPRedistributable

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

REM add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

REM unblock
%pwrsh% "Unblock-File -Path .\*.ps1"

REM execute
%pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


ECHO END %date%-%time%
EXIT
