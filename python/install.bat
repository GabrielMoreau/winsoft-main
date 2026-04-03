
REM
REM   Python
REM

REM Name
SET softname=Python

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__
SET shortversion=__VERSIONSHORT__


:INSTALLED
SET INSTALLED=0
@ECHO [INFO] Test HKLM (computer)
reg query "HKLM\SOFTWARE\Python\PythonCore\%shortversion%\InstallPath" >nul 2>&1
IF "%ERRORLEVEL%"=="0" SET INSTALLED=1
VER >NUL


@ECHO [INFO] Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

@ECHO [INFO] Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

@ECHO [INFO] Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET RETURNCODE=0


@ECHO [INFO] Execute pre-install script
IF EXIST ".\pre-install.ps1" %pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


@ECHO [INFO] Silent install %softname%
IF "%INSTALLED%"=="1" (
  ScriptRunner.exe -appvscript python-%softversion%-amd64.exe /repair /quiet /log "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
) ELSE (
  ScriptRunner.exe -appvscript python-%softversion%-amd64.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 Include_launcher=1 /log "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
)
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


:POSTINSTALL
@ECHO [INFO] Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


:END
@ECHO [END] %date%-%time%
EXIT %RETURNCODE%
