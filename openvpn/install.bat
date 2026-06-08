
REM
REM   OpenVPN
REM

REM Name
SET "softname=OpenVPN"

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
REM Only for version 2.6: ADDLOCAL=OpenVPN.GUI,OpenVPN,OpenVPN.GUI.OnLogon,Drivers.TAPWindows6,Drivers
ScriptRunner.exe -appvscript MsiExec.exe /i "openvpn-connect-%softversion%_signed.msi" /qn /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"


:POSTINSTALL
@ECHO [INFO] Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\OpenVPN Connect.lnk"          DEL /F /Q "%PUBLIC%\Desktop\OpenVPN Connect.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\OpenVPN Connect.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\OpenVPN Connect.lnk"


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
