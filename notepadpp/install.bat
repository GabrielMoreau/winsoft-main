@ECHO OFF

REM Hide the Window

"cmdow.exe" @ /hid


SET softexe=npp.8.3.Installer.x64.exe
SET softversion=8.3
SET softpatch=1
SET softname=Notepad++
SET regkey=Notepad++


"%softexe%" /S


REM Change Add and Remove values

 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS)"
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"


EXIT
