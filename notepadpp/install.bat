REM @ECHO OFF

REM Hide the Window
REM "cmdow.exe" @ /hid

REM
REM   Notepad++
REM

REM General parameter
SET softversion=8.3
SET softexe=npp.%softversion%.Installer.x64.exe
SET softpatch=4
SET softname=Notepad++
SET regkey=Notepad++


REM Kill running process
taskkill /IM notepadpp.exe /F


REM Uninstall previous version
IF EXIST "%ProgramFiles%\Notepad++\uninstall.exe" (
  "%ProgramFiles%\Notepad++\uninstall.exe" /S
  ping 127.0.0.1 -n 15 > nul)
IF EXIST "%ProgramFiles%\Notepad++" (
  RMDIR /S "%ProgramFiles%\Notepad++"
)


REM Silent install
"%softexe%" /S


REM Disable auto update
IF EXIST "%ProgramFiles%\Notepad++\updater_disable" (
  RMDIR /S "%ProgramFiles%\Notepad++\updater_disable"
)
IF EXIST "%ProgramFiles%\Notepad++\updater" (
  RENAME "C:\%ProgramFiles%\Notepad++\updater" "updater_disable"
)

REM Better reg uninstall key
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS)"
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"

PAUSE
EXIT
