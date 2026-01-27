
REM
REM   Notepad++
REM

REM Name
SET softname=Notepad++

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

@ECHO [INFO] Version parameter (auto update by Makefile)
SET softversion=__VERSION__
SET softexe=npp.%softversion%.Installer.x64.exe
SET regkey=Notepad++


@ECHO [INFO] Kill running process
TASKKILL /T /F /IM notepad++.exe


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


@ECHO [INFO] Uninstall previous version
IF EXIST "%ProgramFiles%\Notepad++\uninstall.exe" (
  ScriptRunner.exe -appvscript "%ProgramFiles%\Notepad++\uninstall.exe" /S -appvscriptrunnerparameters -wait -timeout=300
)

SET /A LOOPCOUNT=0
:WAIT
SET /A LOOPCOUNT+=1
IF %LOOPCOUNT% GEQ 31 (
  @ECHO [ERROR] Too many loop before uninstall finish - Continue and cross our fingers!
  GOTO NEXT
)
@ECHO [INFO] Loop counter: %LOOPCOUNT%
ping 127.0.0.1 -n 6 > NUL
REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 GOTO WAIT
REG QUERY "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 GOTO WAIT
ping 127.0.0.1 -n 3 > NUL


:NEXT

@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript "%softexe%" /S -appvscriptrunnerparameters -wait -timeout=300
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


:POSTINSTALL
@ECHO [INFO] Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


@ECHO [INFO] Disable auto update
IF EXIST "%ProgramFiles%\Notepad++\updater_disable" (
  RMDIR /S /Q "%ProgramFiles%\Notepad++\updater_disable"
)
IF EXIST "%ProgramFiles%\Notepad++\updater" (
  RENAME "%ProgramFiles%\Notepad++\updater" "updater_disable"
)


:END
@ECHO [END] %date%-%time%
EXIT %RETURNCODE%
