
REM
REM   Signal-Desktop
REM

REM Name
SET "softname=Signal-Desktop"

SET "logdir=__LOGDIR__"
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET "softversion=__VERSION__"
SET "regkey=7d96caee-06e6-597c-9f2f-c7bb2e0948b4"
SET "shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Signal-Desktop.lnk"
SET "qexeadmin=__QEXEADMIN__"
SET "mainexe=%ProgramData%\signal-desktop\Signal.exe"


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
ScriptRunner.exe -appvscript signal-desktop-win-x64-%softversion%.exe /S /D=%ProgramData%\signal-desktop -appvscriptrunnerparameters -wait -timeout=300
IF "%RETURNCODE%"=="0" SET "RETURNCODE=%ERRORLEVEL%"

@ECHO [INFO] Copy uninstall script
COPY /A /Y "uninstall.bat" "%ProgramData%\signal-desktop\uninstall.bat"


@ECHO [INFO] Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Signal.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Signal.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Signal.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Signal.lnk"
IF EXIST "%USERPROFILE%\Desktop\Signal.lnk"     DEL /F /Q "%USERPROFILE%\Desktop\Signal.lnk"
IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Signal-Desktop.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Signal-Desktop.lnk"


@ECHO [INFO] Better reg uninstall key
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname%  (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="Signal %softversion%"
>> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\ProgramData\\signal-desktop\\uninstall.bat"
>> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\ProgramData\\signal-desktop"
>> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\ProgramData\\signal-desktop"
>> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\ProgramData\\signal-desktop\\Signal.exe,0"
>> tmp_install.reg ECHO "URLInfoAbout"="https://signal-desktop.org/"
>> tmp_install.reg ECHO "Publisher"="Signal Messenger, LLC"
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"

REM HKU	Signal 6.43.2	Signal Messenger, LLC	6.43.2	7d96caee-06e6-597c-9f2f-c7bb2e0948b4	"C:\ProgramData\signal-desktop\Uninstall Signal.exe" /currentuser
@ECHO [INFO] Clean reg uninstall key in HKU
REG QUERY "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF NOT "%ERRORLEVEL%"=="0" GOTO NEXT
REG QUERY "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /v "UninstallString" | FIND /N "%SystemDrive%\ProgramData\signal-desktop" > NUL && (
  @ECHO [INFO] REG DELETE HKU
  REG DELETE "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
  GOTO POSTINSTALL
  )

:NEXT
@ECHO [INFO] Nice: no reg uninstall key in HKU


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
