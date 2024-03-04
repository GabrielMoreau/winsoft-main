
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
SET regkey=windirstat
SET softexec=windirstat%softversion%_setup.exe
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%softname%.lnk


ECHO Silent install %softname%
ScriptRunner.exe -appvscript "%softexec%" /S -appvscriptrunnerparameters -wait -timeout=300


ECHO Copy uninstall script
IF EXIST "%ProgramFiles(x86)%\WinDirStat\Uninstall.exe" (
  COPY /A /Y "uninstall.bat" "%ProgramFiles(x86)%\WinDirStat\uninstall.bat"
)


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Create shortcut
IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs" (
  %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%shortcut%'); $SC.TargetPath = '%ProgramFiles(x86)%\WinDirStat\windirstat.exe'; $SC.Save();" -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile
)


ECHO Clean register
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)
reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)

ECHO Better reg uninstall key
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname%  (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="%softname% %softversion%"
>> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files (x86)\\WinDirStat\\uninstall.bat"
>> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files (x86)\\WinDirStat"
>> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files (x86)\\WinDirStat"
>> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files (x86)\\WinDirStat\\windirstat.exe,0"
>> tmp_install.reg ECHO "URLInfoAbout"="http://windirstat.info/"
>> tmp_install.reg ECHO "Publisher"="The authors of WinDirStat"
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"


ECHO END %date%-%time%
EXIT
