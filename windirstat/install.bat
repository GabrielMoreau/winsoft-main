
REM
REM   WinDirStat
REM

REM Name
SET softname=WinDirStat

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
REM SET regkey=windirstat
REM SET softexec=windirstat%softversion%_setup.exe
REM SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%softname%.lnk


REM Uninstall old version 1
IF EXIST "%ProgramFiles(x86)%\WinDirStat\Uninstall.exe" (
  "%ProgramFiles(x86)%\WinDirStat\Uninstall.exe"
)
REM Clean old reg uninstall key
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\windirstat"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\windirstat" /F
)
REM Clean old x86 folder
IF EXIST "%ProgramFiles(x86)%\WinDirStat" RMDIR /S /Q "%ProgramFiles(x86)%\WinDirStat"


ECHO Silent install %softname%
REM ScriptRunner.exe -appvscript "%softexec%" /S -appvscriptrunnerparameters -wait -timeout=300
ScriptRunner.exe -appvscript MsiExec.exe /i WinDirStat-%softversion%-x64.msi /qn /norestart DESKTOP_SHORTCUT=0 STARTMENU_SHORTCUT=1 REBOOT=ReallySuppress /L*v "%logdir%\%softname%-MSI.log"  -appvscriptrunnerparameters -wait -timeout=300

REM ECHO Copy uninstall script
REM IF EXIST "%ProgramFiles(x86)%\WinDirStat\Uninstall.exe" (
REM   COPY /A /Y "uninstall.bat" "%ProgramFiles(x86)%\WinDirStat\uninstall.bat"
REM )


REM ECHO Search PowerShell
REM SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
REM IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

REM ECHO Create shortcut
REM IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs" (
REM   %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%shortcut%'); $SC.TargetPath = '%ProgramFiles(x86)%\WinDirStat\windirstat.exe'; $SC.Save();" -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile
REM )


REM ECHO Clean register
REM reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
REM IF %ERRORLEVEL% EQU 0 (
REM   REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
REM )
REM reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
REM IF %ERRORLEVEL% EQU 0 (
REM   REG DELETE "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
REM )

REM ECHO Better reg uninstall key
REM  > tmp_install.reg ECHO Windows Registry Editor Version 5.00
REM >> tmp_install.reg ECHO.
REM >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
REM >> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
REM >> tmp_install.reg ECHO "Comments"="%softname%  (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
REM >> tmp_install.reg ECHO "DisplayName"="%softname% %softversion%"
REM >> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files (x86)\\WinDirStat\\uninstall.bat"
REM >> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files (x86)\\WinDirStat"
REM >> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files (x86)\\WinDirStat"
REM >> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files (x86)\\WinDirStat\\windirstat.exe,0"
REM >> tmp_install.reg ECHO "URLInfoAbout"="http://windirstat.info/"
REM >> tmp_install.reg ECHO "Publisher"="The authors of WinDirStat"
REM >> tmp_install.reg ECHO.
REM regedit.exe /S "tmp_install.reg"


ECHO END %date%-%time%
EXIT
