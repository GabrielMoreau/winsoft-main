
REM
REM   Filezilla
REM

REM Name
SET softname=FileZilla-Client

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

REM Version parameter (auto update by Makefile)
SET softversion=__VERSION__
SET softexe=FileZilla_%softversion%_win64-setup.exe


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


@ECHO [INFO] Uninstall previous version if exist
IF EXIST "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" (
  ScriptRunner.exe -appvscript "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" /S -appvscriptrunnerparameters -wait -timeout=300
  IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%
)
IF EXIST "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" (
  ScriptRunner.exe -appvscript "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" /S -appvscriptrunnerparameters -wait -timeout=300
  IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%
)
IF EXIST "%ProgramFiles(x86)%\FileZilla FTP Client\uninstall.exe" (
  ScriptRunner.exe -appvscript "%ProgramFiles(x86)%\FileZilla FTP Client\uninstall.exe" /S -appvscriptrunnerparameters -wait -timeout=300
  IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%
)
IF EXIST "%ProgramFiles(x86)%\FileZilla FTP Client\uninstall.exe" (
  ScriptRunner.exe -appvscript "%ProgramFiles(x86)%\FileZilla FTP Client\uninstall.exe" /S -appvscriptrunnerparameters -wait -timeout=300
  IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%
)


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript "%softexe%" /user=all /S -appvscriptrunnerparameters -wait -timeout=300
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


@ECHO [INFO] Disable welcome and check update
IF EXIST "%ProgramFiles%\FileZilla FTP Client" (
  COPY /A /Y "fzdefaults.xml" "%ProgramFiles%\FileZilla FTP Client\fzdefaults.xml"
)
IF EXIST "%ProgramFiles(x86)%\FileZilla FTP Client" (
  COPY /A /Y "fzdefaults.xml" "%ProgramFiles(x86)%\FileZilla FTP Client\fzdefaults.xml"
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
