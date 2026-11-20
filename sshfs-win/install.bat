
REM
REM   SSHFS-Win
REM

REM Name
SET "softname=SSHFS-Win"

SET "logdir=__LOGDIR__"
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :BEGIN 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:BEGIN

@ECHO [BEGIN] %date%-%time%

SET "WinfspVersion=__WINFSP_VERSION__"
SET "SshfsVersion=__SSHFS_VERSION__"
SETLOCAL EnableDelayedExpansion


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
SET /A OKWINFSP=%RETURNCODE% %% 2
SET /A OKSSHFS=%RETURNCODE% %% 3
SET "RETURNCODE=0"


@ECHO [INFO] Silent install %softname%
IF %OKWINFSP% NEQ 0 (
  @ECHO [INFO] Silent install WinFSP - https://github.com/billziss-gh/winfsp
  ScriptRunner.exe -appvscript MsiExec.exe /i winfsp-%WinfspVersion%.msi /qn /norestart /L*v "%logdir%\%softname%-WinFSP-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
  IF "!RETURNCODE!"=="0" SET "RETURNCODE=!ERRORLEVEL!"
)
IF %OKSSHFS% NEQ 0 (
  @ECHO [INFO] Silent install SSHFS-Win - https://github.com/billziss-gh/sshfs-win
  ScriptRunner.exe -appvscript MsiExec.exe /i sshfs-win-%SshfsVersion%-x64.msi /qn /norestart /L*v "%logdir%\%softname%-SSHFS-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
  IF "!RETURNCODE!"=="0" SET "RETURNCODE=!ERRORLEVEL!"
)


:POSTINSTALL
@ECHO [INFO] Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"


:END
@ECHO [END] %date%-%time%
EXIT %RETURNCODE%
