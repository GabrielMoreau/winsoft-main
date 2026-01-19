
REM
REM   MSEdge
REM

REM Name
SET softname=MSEdge

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
SET RETURNCODE=0


ECHO Execute pre-install script
IF EXIST ".\pre-install.ps1" %pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


ECHO Silent install %softname%
ScriptRunner.exe -appvscript MsiExec.exe /i MicrosoftEdgeEnterpriseX64-%softversion%.msi DONOTCREATEDESKTOPSHORTCUT=true DONOTCREATETASKBARSHORTCUT=true /qn /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%
IF %RETURNCODE% EQU 1603 (
  ECHO 0 or 1603 are good exit code for %softname% installer!
  SET RETURNCODE=0
)


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
