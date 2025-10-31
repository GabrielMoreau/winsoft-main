
REM
REM   VOSviewer
REM

REM Name
SET softname=VOSviewer

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET "softversion=__VERSION__"
SET "process=VOSviewer.exe"
SET "installfolder=VOSviewer"
SET "regkey=VOSviewer_is1"
SET "shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\VOSviewer.lnk"
SET "sc_target=%ProgramFiles%\%installfolder%\jdk-__JDKVERSION__\bin\javaw.exe"
SET "sc_args=-jar .\VOSviewer-%softversion%.jar"
SET "sc_icon=%ProgramFiles%\%installfolder%\VOSviewer.ico"


ECHO Clean old version before install
CALL .\uninstall.bat
IF EXIST "%ProgramFiles%\%installfolder%" RMDIR /S /Q "%ProgramFiles%\%installfolder%"


ECHO Silent install %softname%
MKDIR "%ProgramFiles%\%installfolder%"
XCOPY "jdk-__JDKVERSION__" "%ProgramFiles%\%installfolder%\jdk-__JDKVERSION__" /S /E /I /Y
COPY /B /Y VOSviewer-1.6.20.jar "%ProgramFiles%\%installfolder%\
COPY /B /Y VOSviewer.ico        "%ProgramFiles%\%installfolder%\
COPY /B /Y VOSviewer.license    "%ProgramFiles%\%installfolder%\

ECHO Copy uninstall script
COPY /A /Y "uninstall.bat" "%ProgramFiles%\%installfolder%\uninstall.bat"

ECHO Good right
ICACLS "%ProgramFiles%\%installfolder%" /grant *S-1-1-0:(OI)(CI)(RX)


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Create shortcut in install folder
IF EXIST "%ProgramFiles%\%installfolder%" (
  %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%ProgramFiles%\%installfolder%\VOSviewer.lnk'); $SC.TargetPath = '%sc_target%'; $SC.Arguments='%sc_args%'; $SC.WorkingDirectory='%ProgramFiles%\%installfolder%'; $SC.IconLocation='%sc_icon%'; $SC.Save();" -NonInteractive -NoProfile
)

ECHO Create shortcut
IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs" (
  %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%shortcut%'); $SC.TargetPath = '%sc_target%'; $SC.Arguments='%sc_args%'; $SC.WorkingDirectory='%ProgramFiles%\%installfolder%'; $SC.IconLocation='%sc_icon%'; $SC.Save();" -NonInteractive -NoProfile
)

ECHO Reg uninstall key
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname%  (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="%softname% %softversion%"
>> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files\\%installfolder%\\uninstall.bat"
>> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files\\%installfolder%"
>> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files\\%installfolder%"
>> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files\\%installfolder%\\VOSviewer.ico"
>> tmp_install.reg ECHO "URLInfoAbout"="https://www.vosviewer.com"
>> tmp_install.reg ECHO "Publisher"="Nees Jan van Eck and Ludo Waltman"
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"


:End
ECHO END %date%-%time%
EXIT
