
REM
REM   FreeCAD
REM

REM Name
SET "softname=FreeCAD"

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
SET "mainexe=%ProgramFiles%\FreeCAD __VERSIONSHORT__\bin\freecad.exe"
SET "MAX_RETRY=1"


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


:REINSTALL
@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript FreeCAD_%softversion%-conda-Windows-x86_64-installer.exe /S -appvscriptrunnerparameters -wait -timeout=600
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"

@ECHO [INFO] Check RETURNCODE [%RETURNCODE%] / [%MAX_RETRY%]
IF NOT "%RETURNCODE%"=="0" (
  IF NOT "%MAX_RETRY%"=="0" (
    @ECHO [WARN] Try installation again
    SET /A MAX_RETRY-=1
    SET "RETURNCODE=0"
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
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\FreeCAD*.lnk"          DEL /F /Q "%PUBLIC%\Desktop\FreeCAD*.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\FreeCAD*.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\FreeCAD*.lnk"


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
