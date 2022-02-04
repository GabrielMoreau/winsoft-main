@ECHO OFF

REM Hide the Window
"cmdow.exe" @ /hid

REM
REM   Filezilla
REM

REM General parameter
SET softversion=3.57.0
SET softpatch=4
SET softexe=FileZilla_%softversion%_win64-setup.exe
SET softname=FileZilla Client
SET regkey=FileZilla Client


REM Uninstall previous version
IF EXIST "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" (
  "C:\Program Files\FileZilla FTP Client\uninstall.exe" /S
  "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" /S
  ping 127.0.0.1 -n 31 > nul
) 


REM Silent install
"%softexe%" /user=all /S
ping 127.0.0.1 -n 31 > nul


REM Disable welcome and check update
COPY /A /Y "fzdefaults.xml" "%ProgramFiles%\FileZilla FTP Client\fzdefaults.xml"


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
