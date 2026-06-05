
REM
REM   Octave
REM

REM Name
SET "softname=Octave"

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
SET "mainexe=%ProgramFiles%\GNU Octave\Octave-__VERSION__\octave-launch.exe"
SET "mainexe=%mainexe%;%ProgramFiles%\GNU Octave\Octave-__VERSION__\octave-launch-firsttime.exe


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
IF %RETURNCODE% EQU 0 SET "RETURNCODE=%ERRORLEVEL%"


@ECHO [INFO] Silent install %softname%
ScriptRunner.exe -appvscript octave-%softversion%-w64-installer.exe /AllUsers /S -appvscriptrunnerparameters -wait -timeout=900
IF %RETURNCODE% EQU 0 SET "RETURNCODE=%ERRORLEVEL%"


:POSTINSTALL
@ECHO [INFO] Execute post-install script
IF EXIST ".\pre-install.ps1" (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
) ELSE (
  IF EXIST ".\post-install.ps1" %pwrsh% -File ".\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1
)
IF %RETURNCODE% EQU 0 SET "RETURNCODE=%ERRORLEVEL%"


@ECHO [INFO] Copy Configuration
IF EXIST "%AppData%\octave\" COPY /A /Y "octave-gui.ini" "%AppData%\octave\octave-gui.ini"


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\GNU Octave (CLI).lnk"          DEL /F /Q "%PUBLIC%\Desktop\GNU Octave (CLI).lnk"
IF EXIST "%PUBLIC%\Desktop\GNU Octave (GUI).lnk"          DEL /F /Q "%PUBLIC%\Desktop\GNU Octave (GUI).lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\GNU Octave (CLI).lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\GNU Octave (CLI).lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\GNU Octave (GUI).lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\GNU Octave (GUI).lnk"


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
