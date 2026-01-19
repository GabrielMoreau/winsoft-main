
REM
REM   XnViewMP
REM

REM Name
SET softname=XnViewMP

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Silent Uninstall %softname% on 32-bit or 64-bit System
IF EXIST "%ProgramFiles%\XnView\unins000.exe"        ScriptRunner.exe -appvscript "%ProgramFiles%\XnView\unins000.exe"        /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300
IF EXIST "%ProgramFiles(x86)%\XnView\unins000.exe"   ScriptRunner.exe -appvscript "%ProgramFiles(x86)%\XnView\unins000.exe"   /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300
IF EXIST "%ProgramFiles%\XnViewMP\unins000.exe"      ScriptRunner.exe -appvscript "%ProgramFiles%\XnViewMP\unins000.exe"      /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300
IF EXIST "%ProgramFiles(x86)%\XnViewMP\unins000.exe" ScriptRunner.exe -appvscript "%ProgramFiles(x86)%\XnViewMP\unins000.exe" /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300
IF EXIST "%ProgramFiles%\XnViewMP\unins001.exe"      ScriptRunner.exe -appvscript "%ProgramFiles%\XnViewMP\unins001.exe"      /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300
IF EXIST "%ProgramFiles(x86)%\XnViewMP\unins001.exe" ScriptRunner.exe -appvscript "%ProgramFiles(x86)%\XnViewMP\unins001.exe" /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300


ECHO Silent install %softname%
ScriptRunner.exe -appvscript XnViewMP-win-%softversion%-x64.exe /VERYSILENT /NORESTART /SUPPRESSMSGBOXES /MERGETASKS=!desktopicon /LOG="%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
SET RETURNCODE=%ERRORLEVEL%


:POSTINSTALL
ECHO Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


:END
ECHO END %date%-%time%
EXIT %RETURNCODE%
