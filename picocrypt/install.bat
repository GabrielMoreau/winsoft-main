REM @ECHO OFF

REM
REM   Picocrypt
REM

REM Name
SET softname=Picocrypt

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET regkey=EvanSu.Picocrypt_is1
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%softname%.lnk

ECHO Silent install %softname%
Picocrypt-Installer-%softversion%.exe /VERYSILENT /NORESTART /DIR="%ProgramFiles%\Picocrypt" /LOG="%logdir%\%softname%-MSI.log"


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Create shortcut
IF EXIST "%ProgramFiles%\Picocrypt\Picocrypt.exe" (
  %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%shortcut%'); $SC.TargetPath = '%ProgramFiles%\Picocrypt\Picocrypt.exe'; $SC.Save();" -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile
)

IF EXIST "%ProgramFiles%\Picocrypt\unins000.exe" (
  ECHO Copy uninstall script
  COPY /A /Y "uninstall.bat" "%ProgramFiles%\Picocrypt\uninstall.bat"

  ECHO Better reg uninstall key
   > tmp_install.reg ECHO Windows Registry Editor Version 5.00
  >> tmp_install.reg ECHO.
  >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
  >> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
  >> tmp_install.reg ECHO "Comments"="%softname%  (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
  >> tmp_install.reg ECHO "DisplayName"="Picocrypt"
  >> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files\\Picocrypt\\uninstall.bat"
  >> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files\\Picocrypt"
  >> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files\\Picocrypt"
  >> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files\\Picocrypt\\Picocrypt.exe,0"
  >> tmp_install.reg ECHO "URLInfoAbout"="https://www.raise3d.eu/"
  >> tmp_install.reg ECHO "Publisher"="Evan Su"
  >> tmp_install.reg ECHO.
  regedit.exe /S "tmp_install.reg"
)


ECHO END %date%-%time%
EXIT
