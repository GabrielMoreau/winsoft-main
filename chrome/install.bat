
REM
REM   Chrome
REM

REM Name
SET softname=Chrome

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


ECHO Silent install %softname%
ScriptRunner.exe -appvscript MsiExec.exe /i "googlechromestandaloneenterprise64-%softversion%.msi" /qn /L*V "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
SET RETURNCODE=%ERRORLEVEL%


:POSTINSTALL
ECHO Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


ECHO Disable auto update
sc stop gupdate
sc config gupdate start= disabled
regedit.exe /S "chrome-parameters.reg"

ECHO Copy preferences
IF EXIST "C:\Program Files (x86)\Google\Chrome\Application\" (
	COPY /B /Y "master_preferences.json" "C:\Program Files (x86)\Google\Chrome\Application\master_preferences"
	)
IF EXIST "C:\Program Files\Google\Chrome\Application\" (
	COPY /B /Y "master_preferences.json" "C:\Program Files\Google\Chrome\Application\master_preferences"
	)

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Google*Chrome.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Google*Chrome.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Google*Chrome.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Google*Chrome.lnk"


:END
ECHO END %date%-%time%
EXIT %RETURNCODE%
