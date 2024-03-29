
REM
REM   VirtualBox
REM

REM Name
SET softname=VirtualBox

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET softextpack=__PACKEXT__

REM PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

REM Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

REM Unblock
%pwrsh% "Unblock-File -Path .\*.ps1"

REM Execute
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


ECHO Silent install %softname%
ScriptRunner.exe -appvscript VirtualBox-%softversion%-Win.exe --silent --extract --path .\ -appvscriptrunnerparameters -wait -timeout=300
FOR %%m IN (*.msi) DO (ScriptRunner.exe -appvscript MsiExec.exe /i "%%m" /qn /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300)


IF EXIST "%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" (
  REM Disable VirtualBox Update
  "%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" setextradata global GUI/UpdateDate "never"

  REM Install Extension Pack
  echo y | "%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" extpack install --replace ".\%softextpack%"
) ELSE (
  REM VirtualBox not well installed
  ECHO VBoxManage is not installed, reinstall VirtualBox...
  EXIT 44
)


ECHO END %date%-%time%
EXIT
