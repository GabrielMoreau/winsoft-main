
REM
REM   SSHFS-Win
REM

REM Name
SET softname=SSHFS-Win

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET WinfspVersion=__WINFSP_VERSION__
SET SshfsVersion=__SSHFS_VERSION__


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET RETURNCODE=0


ECHO Execute pre-install script
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


ECHO Silent install WinFSP - https://github.com/billziss-gh/winfsp
ScriptRunner.exe -appvscript MsiExec.exe /quiet /qn /i winfsp-%WinfspVersion%.msi -appvscriptrunnerparameters -wait -timeout=300

ECHO Silent install SSHFS-Win - https://github.com/billziss-gh/sshfs-win
ScriptRunner.exe -appvscript MsiExec.exe /quiet /qn /i sshfs-win-%SshfsVersion%-x64.msi -appvscriptrunnerparameters -wait -timeout=300


ECHO Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)



ECHO END %date%-%time%
EXIT
