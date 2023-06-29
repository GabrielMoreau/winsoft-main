REM @ECHO OFF

REM
REM   HPImageAssist
REM

REM Name
SET softname=HPImageAssist

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=91.5.1
SET softpatch=1
SET regkey=%softname%
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\HP Image Assistant.lnk


ECHO Silent install %softname%
hp-hpia-%softversion%.exe /s /e /f "%ProgramFiles%\HP\HPIA"


ECHO Wait 15 s
ping 127.0.0.1 -n 15 > NUL

ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

IF EXIST "%ProgramFiles%\HP\HPIA\HPImageAssistant.exe" (
  ECHO Copy uninstall script
  COPY /A /Y "uninstall.bat" "%ProgramFiles%\HP\HPIA\uninstall.bat"

  ECHO Create shortcut
  IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs" (
    %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%shortcut%'); $SC.TargetPath = '%ProgramFiles%\HP\HPIA\HPImageAssistant.exe'; $SC.Save();" -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile
  )

  ECHO Better reg uninstall key
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname%  (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="HP Image Assistant %softversion% (HPIA)"
>> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files\\HP\\HPIA\\uninstall.bat"
>> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files\\HP\\HPIA"
>> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files\\HP\\HPIA"
>> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files\\HP\\HPIA\\HPImageAssistant.exe,0"
>> tmp_install.reg ECHO "URLInfoAbout"="https://ftp.ext.hp.com/pub/caps-softpaq/cmit/HPIA.html"
>> tmp_install.reg ECHO "Publisher"="HP Inc."
>> tmp_install.reg ECHO.
  regedit.exe /S "tmp_install.reg"
)


ECHO END %date%-%time%
EXIT
