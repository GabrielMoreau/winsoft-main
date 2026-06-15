
REM
REM   Action-WindowsCleanSpace
REM

REM Name
SET "softname=Action-WindowsCleanSpace"

SET "logdir=__LOGDIR__"
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%


@ECHO [INFO] Search PowerShell
SET "pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe"
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET "pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe"

@ECHO [INFO] Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

@ECHO [INFO] Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET "RETURNCODE=0"


@ECHO [INFO] Execute pre-install script
IF EXIST ".\pre-install.ps1" %pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"


@ECHO [INFO] AnalyzeComponentStore
Dism.exe /Online /Cleanup-Image /AnalyzeComponentStore
IF NOT "%ERRORLEVEL%"=="0" (
@ECHO [INFO] RestoreHealth
  Dism.exe /Online /Cleanup-Image /RestoreHealth
  sfc /scannow
)

@ECHO [INFO] Get Packages Table
Dism.exe /Online /Get-Packages /Format:Table

@ECHO [INFO] CleanUp
Dism.exe /Online /Cleanup-Image /StartComponentCleanup
REM Dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"


:END
@ECHO [END] %date%-%time%
EXIT %RETURNCODE%
