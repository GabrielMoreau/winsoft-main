REM @ECHO OFF

REM
REM   Telegram
REM

REM Name
SET softname=Telegram

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET softpatch=__PATCH__
SET regkey=Telegram Desktop
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Telegram.lnk
SET process=Telegram.exe


ECHO Kill running process
taskkill /T /F /IM %process%

ECHO Clean old version before install
CALL .\uninstall.bat


ECHO Silent install %softname%
MOVE "Telegram" "%ProgramFiles%\%regkey%"

ECHO Copy uninstall script
COPY /A /Y "uninstall.bat" "%ProgramFiles%\%regkey%\uninstall.bat"


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Create shortcut
IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs" (
  %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%shortcut%'); $SC.TargetPath = '%ProgramFiles%\%regkey%\Telegram.exe'; $SC.Save();" -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile
)


ECHO Better reg uninstall key
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname%  (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="%regkey% %softversion%"
>> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files\\%regkey%\\uninstall.bat"
>> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files\\%regkey%"
>> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files\\%regkey%"
>> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files\\%regkey%\\Telegram.exe,0"
>> tmp_install.reg ECHO "URLInfoAbout"="https://telegram.org/"
>> tmp_install.reg ECHO "Publisher"="Telegram FZ-LLC"
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"

REM HKU	Telegram Desktop	Telegram FZ-LLC	4.8.3	{53F49750-6209-4FBF-9CA8-7A333C87D1ED}_is1	"C:\Program Files\Telegram Desktop\unins000.exe"	
ECHO Clean reg uninstall key in HKU
REG QUERY "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Uninstall\{53F49750-6209-4FBF-9CA8-7A333C87D1ED}_is1"
IF %ERRORLEVEL% NEQ 0 GOTO Next
REG QUERY "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Uninstall\{53F49750-6209-4FBF-9CA8-7A333C87D1ED}_is1" /v "UninstallString" | FIND /N "%SystemDrive%\Program Files\Telegram Desktop\unins000.ex" > NUL && (
  ECHO REG DELETE HKU
  REG DELETE "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Uninstall\{53F49750-6209-4FBF-9CA8-7A333C87D1ED}_is1" /F
  GOTO End
  )

:Next
ECHO Nice: no reg uninstall key in HKU
ECHO END %date%-%time%
EXIT 0
  

:End
ECHO END %date%-%time%
EXIT
