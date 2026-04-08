
REM
REM   VSBuildTools
REM

REM Name
SET softname=VSBuildTools

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__


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
REM ScriptRunner.exe -appvscript vs_BuildTools-%softversion%.exe --quiet --wait --norestart --add Microsoft.VisualCpp.BuildTools;Microsoft.VisualStudio.Component.VC.CMake.Project;includeRecommended --log "%logdir%\%softname%-MSI.log -appvscriptrunnerparameters -wait -timeout=300
START "" /B vs_BuildTools-%softversion%.exe --quiet --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.CMake.Project
SET /A ELAPSED=0
:WAITLOOP
timeout /t 5 /nobreak >nul
SET /A ELAPSED+=5
TASKLIST /fi "imagename eq vs_BuildTools-%softversion%.exe" | find /i "vs_BuildTools-%softversion%.exe" >NUL
IF %ERRORLEVEL%==0 (
  IF %ELAPSED% GEQ 600 (
    TASKKILL /T /F /IM vs_BuildTools-%softversion%.exe || VER >NUL
    SET RETURNCODE=140
    GOTO POSTINSTALL
  ) ELSE (
    GOTO WAITLOOP
  )
) ELSE (
  timeout /t 90 /nobreak >nul
  VER >NUL
)


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
