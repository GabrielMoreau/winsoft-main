
REM
REM   XMind
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

@ECHO [BEGIN] %date%-%time%

SET "softversion=__VERSION__"
SET "installfolder=Xmind"
SET "regkey=Xmind_is1"
SET "shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Xmind.lnk"
SET "sc_target=%ProgramFiles%\%installfolder%\Xmind.exe"
SET "process=Xmind.exe"


@ECHO [INFO] Clean old version before install
CALL .\pre-install.bat
IF EXIST "%ProgramFiles%\%installfolder%" RMDIR /S /Q "%ProgramFiles%\%installfolder%"


@ECHO [INFO] Silent install %softname%
MOVE pkg "%ProgramFiles%\%installfolder%"
IF NOT EXIST "%sc_target%" GOTO FAILED


@ECHO [INFO] Copy uninstall script
COPY /A /Y "pre-install.bat" "%ProgramFiles%\%installfolder%\pre-install.bat"
COPY /A /Y "uninstall.bat"   "%ProgramFiles%\%installfolder%\uninstall.bat"

@ECHO [INFO] Proper right to files
ICACLS "%ProgramFiles%\%installfolder%" /grant *S-1-1-0:(OI)(CI)(RX)


@ECHO [INFO] Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

@ECHO [INFO] Create shortcut
IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs" (
  %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%shortcut%'); $SC.TargetPath = '%sc_target%'; $SC.Save();" -NoLogo -NonInteractive -NoProfile
)


@ECHO [INFO] Reg uninstall key
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="Xmind %softversion%"
>> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files\\%installfolder%\\uninstall.bat"
>> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files\\%installfolder%"
>> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files\\%installfolder%"
>> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files\\%installfolder%\\Xmind.exe,0"
>> tmp_install.reg ECHO "URLInfoAbout"="https://xmind.com/"
>> tmp_install.reg ECHO "Publisher"="XMIND LTD."
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"

GOTO END


:FAILED
@ECHO [INFO] Failed to install %softname%
@ECHO [END] %date%-%time%
EXIT 44


:END
@ECHO [END] %date%-%time%
EXIT
