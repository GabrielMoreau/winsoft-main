REM @ECHO OFF

REM Hide the Window
REM "cmdow.exe" @ /hid

REM
REM   SSHFS-Win
REM

REM Name
SET softname=SSHFS-Win

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL

SET WinfspVersion=1.10.22006
SET SshfsVersion=3.5.20357
SET ManagerVersion=1.3.1
SET SiriKaliVersion=1.4.8
SET PkgVersion=9

SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

REM
REM Install WinFSP - https://github.com/billziss-gh/winfsp
REM
msiexec /quiet /qn /i winfsp-%WinfspVersion%.msi
REM ping 127.0.0.1 -n 6 > nul

REM
REM Install SSHFS-Win - https://github.com/billziss-gh/sshfs-win
REM
msiexec /quiet /qn /i sshfs-win-%SshfsVersion%-x64.msi
REM ping 127.0.0.1 -n 6 > nul

REM
REM Install link in Start Menu
REM
%pwrsh% -File "install.ps1"

EXIT
