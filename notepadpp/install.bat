@ECHO OFF

REM Hide the Window
"cmdow.exe" @ /hid

REM
REM   Notepad++
REM

REM General parameter
SET softversion=8.3
SET softexe=npp.%softversion%.Installer.x64.exe
SET softpatch=3
SET softname=Notepad++
SET regkey=Notepad++


REM Uninstall previous version
IF EXIST "C:\Program Files\Notepad++\uninstall.exe" (
  "C:\Program Files\Notepad++\uninstall.exe" /S
) 
ping 127.0.0.1 -n 31 > nul


REM Silent install
"%softexe%" /S
ping 127.0.0.1 -n 31 > nul


REM Disable auto update
IF EXIST "C:\Program Files\Notepad++\updater_disable" (
  RMDIR /S "C:\Program Files\Notepad++\updater_disable"
) 
RENAME "C:\Program Files\Notepad++\updater" "updater_disable"


REM Better reg uninstall key
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS)"
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"


EXIT
