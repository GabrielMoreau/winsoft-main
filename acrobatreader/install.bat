
REM
REM   AcrobatReader
REM

REM Name
SET softname=AcrobatReader

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%


SET softversion=__VERSION__
SET MAX_RETRY=1


@ECHO [INFO] Kill running process
TASKKILL /T /F /IM Acrobat.exe /IM AcroCEF.exe /IM AdobeCollabSync.exe


@ECHO [INFO] Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

@ECHO [INFO] Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

@ECHO [INFO] Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET RETURNCODE=0


@ECHO [INFO] Execute pre-install script
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
IF %ERRORLEVEL% EQU 147 (
  @ECHO [INFO] Silent Update %softname%
  ScriptRunner.exe -appvscript MsiExec.exe /update AcroRdrDCx64Upd%softversion%.msp /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES DISABLEDESKTOPSHORTCUT=1 DISABLE_ARM_SERVICE_INSTALL=1 /L*V "%logdir%\%softname%-MSP.log" -appvscriptrunnerparameters -wait -timeout=600
  GOTO POSTINSTALL
) ELSE (
  IF %ERRORLEVEL% EQU 146 (
    @ECHO [INFO] Already installed %softname% at same or newer version
    GOTO POSTINSTALL
  )
)

:REINSTALL
@ECHO [INFO] Silent Install %softname%
IF EXIST "AcroRdrDCx64%softversion%_MUI.exe" (
  ScriptRunner.exe -appvscript AcroRdrDCx64%softversion%_MUI.exe /sAll /rs /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES DISABLEDESKTOPSHORTCUT=1 DISABLE_ARM_SERVICE_INSTALL=1 /L*V "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=600
) ELSE (
    @ECHO [ERROR] Installer is not in the archive!
)

@ECHO [INFO] Check if installed
IF EXIST "%ProgramFiles%\Adobe\Acrobat DC\Acrobat\Acrobat.exe" (
  GOTO POSTINSTALL
) ELSE (
  IF "%MAX_RETRY%"=="0" (
    @ECHO [ERROR] MAX_RETRY installation done and no %softname%
    SET RETURNCODE=140
    GOTO END
  ) ELSE (
    @ECHO [WARN] Try installation again
    SET /A MAX_RETRY-=1
    GOTO REINSTALL
  )
)


:POSTINSTALL
@ECHO [INFO] Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


@ECHO [INFO] Remove AdobeCollabSync
IF EXIST "%ProgramFiles%\Adobe\Acrobat DC\Acrobat\AdobeCollabSync.exe" (
  IF EXIST "%ProgramFiles%\Adobe\Acrobat DC\Acrobat\AdobeCollabSync.exe.org" DEL /F /Q "%ProgramFiles%\Adobe\Acrobat DC\Acrobat\AdobeCollabSync.exe.org"
  RENAME "%ProgramFiles%\Adobe\Acrobat DC\Acrobat\AdobeCollabSync.exe" "AdobeCollabSync.exe.org"
)

@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Adobe*Reader*.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Adobe*Reader*.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Adobe*Reader*.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Adobe*Reader*.lnk"
IF EXIST "%PUBLIC%\Desktop\Adobe*Acrobat.lnk"           DEL /F /Q "%PUBLIC%\Desktop\Adobe*Acrobat.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Adobe*Acrobat.lnk"  DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Adobe*Acrobat.lnk"


:END
@ECHO [END] %date%-%time%
EXIT %RETURNCODE%
