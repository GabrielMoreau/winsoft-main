
REM
REM   HPSupportAssist
REM

REM Name
SET softname=HPSupportAssist

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


@ECHO [INFO] Disabled automatic install, notifytray and notifypopup
REG ADD "HKLM\SOFTWARE\WOW6432Node\Hewlett-Packard\HPActiveSupport\HPSF" /v NotifyTray /t REG_SZ /d 0 /f
REG ADD "HKLM\SOFTWARE\WOW6432Node\Hewlett-Packard\HPActiveSupport\HPSF" /v NotifyPopup /t REG_SZ /d 0 /f
REG ADD "HKLM\SOFTWARE\WOW6432Node\Hewlett-Packard\HPActiveSupport\HPHC" /v Install /t REG_SZ /d 0 /f


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript InstallHPSA.exe /S /v/qn -appvscriptrunnerparameters -wait -timeout=1200
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


:POSTINSTALL
@ECHO [INFO] Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\HP*Support*Assistant.lnk"          DEL /F /Q "%PUBLIC%\Desktop\HP*Support*Assistant.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\HP*Support*Assistant.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\HP*Support*Assistant.lnk"


:END
@ECHO [END] %date%-%time%
EXIT %RETURNCODE%
