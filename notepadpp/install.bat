@ECHO OFF

REM Hide the Window
"cmdow.exe" @ /hid


REM General parameter
SET softexe=npp.8.3.Installer.x64.exe
SET softversion=8.3
SET softpatch=1
SET softname=Notepad++
SET regkey=Notepad++


REM Silent install
"%softexe%" /S


REM Disable auto update
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
