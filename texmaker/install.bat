
REM
REM   TexMaker
REM

REM Name
SET softname=TexMaker

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__
SET process=Texmaker.exe


@ECHO [INFO] Kill running process
TASKKILL /T /F /IM %process%


@ECHO [INFO] Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

@ECHO [INFO] Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

@ECHO [INFO] Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET RETURNCODE=0


@ECHO [INFO] Execute pre-install script
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


@ECHO [INFO] Silent install
ScriptRunner.exe -appvscript MsiExec.exe /i "Texmaker_%softversion%_Win_x64.msi" /qn /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


@ECHO [END] %date%-%time%
EXIT
