
REM
REM   Filezilla
REM

REM Name
SET softname=XMind

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

REM Version parameter (auto update by Makefile)
SET softversion=__VERSION__
SET regkey=Xmind_is1
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Xmind.lnk
SET target=%ProgramFiles%\Xmind\Xmind.exe
SET process=Xmind.exe


ECHO Clean old version before install
CALL .\pre-install.bat
IF EXIST "%ProgramFiles%\Xmind" RMDIR /S /Q "%ProgramFiles%\Xmind"


ECHO Silent install %softname%
MOVE pkg "%ProgramFiles%\Xmind"
REM MKDIR "%ProgramFiles%\Xmind\"
REM XCOPY pkg\* "%ProgramFiles%\Xmind\" /E /I /H /Y
REM ScriptRunner.exe -appvscript Xmind-for-Windows-x64bit-%softversion%.exe /S /D="%ProgramFiles%\Xmind" -appvscriptrunnerparameters -wait -timeout=300
IF NOT EXIST "%target%" GOTO FAILED


ECHO Copy uninstall script
COPY /A /Y "uninstall.bat" "%ProgramFiles%\Xmind\uninstall.bat"


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Create shortcut
IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs" (
  %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%shortcut%'); $SC.TargetPath = '%target%'; $SC.Save();" -NoLogo -NonInteractive -NoProfile
)


ECHO Remove desktop shortcut
REM IF EXIST "%PUBLIC%\Desktop\Xmind.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Xmind.lnk"
REM IF EXIST "%ALLUSERSPROFILE%\Desktop\Xmind.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Xmind.lnk"


ECHO Better reg uninstall key
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="Xmind %softversion%"
>> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files\\Xmind\\Uninstall Xmind.exe"
>> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files\\Xmind"
>> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files\\Xmind"
>> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files\\Xmind\\Xmind.exe,0"
>> tmp_install.reg ECHO "URLInfoAbout"="https://xmind.com/"
>> tmp_install.reg ECHO "Publisher"="XMIND LTD."
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"
)

GOTO END


:FAILED
ECHO Failed to install %softname%
ECHO END %date%-%time%
EXIT 44


:END
ECHO END %date%-%time%
EXIT
