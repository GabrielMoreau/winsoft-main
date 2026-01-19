
REM
REM   PrusaSlicer
REM

REM Name
SET softname=PrusaSlicer

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET regkey=PrusaSlicer_is1
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\PrusaSlicer.lnk
SET mainexe=%ProgramFiles%\Prusa3D\%softname%\prusa-slicer.exe
SET process=prusa-slicer.exe


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO Unblock PowerShell Script
%pwrsh% "Unblock-File -Path .\*.ps1"
SET RETURNCODE=0


ECHO Kill running process
TASKKILL /T /F /IM %process%

ECHO Clean old version before install
CALL .\uninstall.bat 1> "%logdir%\%softname%-DEL.log" 2>&1


ECHO Silent install %softname%
REM prusa3d_win_%softversion%.exe /qn /norestart /exenoupdates /exenoui /exelog "%logdir%\%softname%-MSI.log"
REM ScriptRunner.exe -appvscript prusa3d_win_%softversion%.exe /qn /norestart /exenoupdates /exenoui /exelog "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
IF EXIST "%ProgramFiles%\Prusa3D" (
  MD "%ProgramFiles%\Prusa3D"
)
MOVE "%softname%" "%ProgramFiles%\Prusa3D\%softname%"

ECHO Copy uninstall script
COPY /A /Y "uninstall.bat" "%ProgramFiles%\Prusa3D\%softname%\uninstall.bat"


ECHO Create shortcut
IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs" (
  %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%shortcut%'); $SC.TargetPath = '%mainexe%'; $SC.Save();" -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile
)


REM HKLM	PrusaSlicer version 2.7.1	Prusa Research s.r.o.	2.7.1	PrusaSlicer_is1	"C:\Program Files\Prusa3D\PrusaSlicer\unins000.exe"
ECHO Better reg uninstall key
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname%  (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="PrusaSlicer version %softversion%"
>> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files\\Prusa3D\\%softname%\\uninstall.bat"
>> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files\\Prusa3D\\%softname%"
>> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files\\Prusa3D\\%softname%"
>> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files\\Prusa3D\\%softname%\\prusa-slicer.exe,0"
>> tmp_install.reg ECHO "URLInfoAbout"="https://www.prusa3d.com/"
>> tmp_install.reg ECHO "Publisher"="Prusa Research s.r.o."
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"


ECHO END %date%-%time%
EXIT
