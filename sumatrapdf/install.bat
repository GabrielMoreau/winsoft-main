
REM
REM   SumatraPDF
REM

REM Name
SET softname=SumatraPDF

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript SumatraPDF-%softversion%-64-install.exe -s -all-users -with-filter -appvscriptrunnerparameters -wait -timeout=300


@ECHO [INFO] Remove desktop link
IF EXIST "%ALLUSERSPROFILE%\Desktop\SumatraPDF.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\SumatraPDF.lnk"
IF EXIST "%ALLUSERSPROFILE%\Bureau\SumatraPDF.lnk"  DEL /F /Q "%ALLUSERSPROFILE%\Bureau\SumatraPDF.lnk"
IF EXIST "%PUBLIC%\Desktop\SumatraPDF.lnk"          DEL /F /Q "%PUBLIC%\Desktop\SumatraPDF.lnk"


@ECHO [INFO] Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

@ECHO [INFO] Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

@ECHO [INFO] Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET RETURNCODE=0

@ECHO [INFO] Execute post-install script
%pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


@ECHO [END] %date%-%time%
EXIT
