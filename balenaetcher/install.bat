
REM
REM   BalenaEtcher
REM

REM Name
SET softname=BalenaEtcher

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET regkey=balena-etcher
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%softname%.lnk
SET process=balenaEtcher.exe


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Kill running process
taskkill /T /F /IM %process%

ECHO Clean old version before install
CALL .\uninstall.bat

ECHO Execute pre-install script to remove HKU version
%pwrsh% -File ".\pre-install.ps1"


ECHO Silent install %softname%
MOVE "BalenaEtcher" "%ProgramFiles%\%regkey%"

ECHO Copy uninstall script
COPY /A /Y "uninstall.bat" "%ProgramFiles%\%regkey%\uninstall.bat"


ECHO Create shortcut
IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs" (
  %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%shortcut%'); $SC.TargetPath = '%ProgramFiles%\%regkey%\balenaEtcher.exe'; $SC.Save();" -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile
)


ECHO Better reg uninstall key
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname%  (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="balenaEtcher %softversion%"
>> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files\\balena-etcher\\uninstall.bat"
>> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files\\balena-etcher"
>> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files\\balena-etcher"
>> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files\\balena-etcher\\balenaEtcher.exe,0"
>> tmp_install.reg ECHO "URLInfoAbout"="https://etcher.balena.io/"
>> tmp_install.reg ECHO "Publisher"="Balena Ltd."
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"


ECHO END %date%-%time%
EXIT
