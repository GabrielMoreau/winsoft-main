REM @ECHO OFF

REM
REM   XournalPP
REM

REM Name
SET softname=XournalPP

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET regkey=Xournal++
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Xournal++.lnk


ECHO Silent install %softname%
xournalpp-%softversion%-windows.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /S /quiet

ECHO Copy uninstall script
COPY /A /Y "uninstall.bat" "%ProgramFiles%\%regkey%\uninstall.bat"


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Create shortcut
IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs" (
  %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%shortcut%'); $SC.TargetPath = '%ProgramFiles%\%regkey%\bin\xournalpp.exe'; $SC.Save();" -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile
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
>> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files\\%regkey%\\bin\\xournalpp.exe,0"
>> tmp_install.reg ECHO "URLInfoAbout"="https://github.com/xournalpp/xournalpp"
>> tmp_install.reg ECHO "Publisher"="Xournal Team"
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"


ECHO END %date%-%time%
EXIT
