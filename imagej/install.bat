ECHO OFF

SET softname=ImageJ

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET softrevision=__REVISION__
SET regkey=ImageJ
SET softpublisher=The ImageJ Fiji Team
SET softiversion=__IVERSION__
SET softnversion=__NVERSION__

SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Adds the rights to run powershell scripts
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO Deletes the ImageJ directory if exist
IF EXIST "%ProgramData%\ImageJ" RMDIR /S /Q "%ProgramData%\ImageJ"

ECHO Creation of the directory
MKDIR "%ProgramData%\ImageJ"

ECHO Copy post-install script
COPY /Y post-install.ps1 "%ProgramData%\ImageJ"

ECHO Execution right on script post-install.ps1
%pwrsh% "Unblock-File -Path ${env:ProgramData}\ImageJ\post-install.ps1"

ECHO Post-install execute
%pwrsh% -File "%ProgramData%\ImageJ\post-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1

ECHO Change Add and Remove values in the register
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softnversion%.%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="%softname% - %softiversion% (Fiji %softversion%-%softrevision%)"
>> tmp_install.reg ECHO "InstallFolder"="C:\\ProgramData\\ImageJ"
>> tmp_install.reg ECHO "Publisher"="%softpublisher%"
>> tmp_install.reg ECHO "UninstallString"="C:\\ProgramData\\ImageJ\\uninstall.bat"
>> tmp_install.reg ECHO "NoModify"=dword:00000001
>> tmp_install.reg ECHO "NoRepair"=dword:00000001
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"


ECHO END %date%-%time%
EXIT
