
REM
REM   VeraCrypt
REM

REM Name
SET "softname=VeraCrypt"

SET "logdir=__LOGDIR__"
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET "softversion=__VERSION__"
SET "qexeadmin=__QEXEADMIN__"
SET "mainexe="


@ECHO [INFO] Search PowerShell
SET "pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe"
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET "pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe"

@ECHO [INFO] Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

@ECHO [INFO] Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET "RETURNCODE=0"


:QEXEADMRESET
IF "%qexeadmin%"=="false" (
  FOR %%F in ("%mainexe:;=" "%") do (
    IF EXIST "%%~F" (
      @ECHO [INFO] Reset ACL on %%~F
      icacls "%%~F" /reset || VER >NUL
    )
  )
)


@ECHO [INFO] Execute pre-install script
IF EXIST ".\pre-install.ps1" %pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript MsiExec.exe /i VeraCrypt-Setup-x64-%softversion%.msi ACCEPTLICENSE=YES INSTALLDESKTOPSHORTCUT=0 /qn /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"
IF "%RETURNCODE%"=="1603" (
  @ECHO [INFO] 0 or 1603 are good exit code for %softname% installer!
  SET "RETURNCODE=0"
)


:POSTINSTALL
@ECHO [INFO] Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\%softname%.lnk"          DEL /F /Q "%PUBLIC%\Desktop\%softname%.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\%softname%.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\%softname%.lnk"


:QEXEADMDENY
IF "%qexeadmin%"=="false" (
  FOR %%F in ("%mainexe:;=" "%") do (
    IF EXIST "%%~F" (
      @ECHO [INFO] Restrict ACL for admin on %%~F
      icacls "%%~F" /deny "*S-1-5-32-544:(X)" || VER >NUL
    )
  )
)


:END
@ECHO [END] %date%-%time%
EXIT %RETURNCODE%
