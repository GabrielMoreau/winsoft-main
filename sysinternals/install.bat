
REM
REM   SysinternalsSuite
REM

REM Name
SET softname=SysinternalsSuite

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__
SET regkey=Sysinternals


@ECHO [INFO] Clean old version before install
CALL .\uninstall.bat


@ECHO [INFO] Silent install %softname%
MOVE "SysinternalsSuite" "%ProgramFiles%\%regkey%"

@ECHO [INFO] Copy uninstall script
COPY /A /Y "uninstall.bat" "%ProgramFiles%\%regkey%\uninstall.bat"


@ECHO [INFO] Better reg uninstall key
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname%  (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="Microsoft Sysinternals Suite %softversion%"
>> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files\\%regkey%\\uninstall.bat"
>> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files\\%regkey%"
>> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files\\%regkey%"
>> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files\\%regkey%\\DiskView.exe,0"
>> tmp_install.reg ECHO "URLInfoAbout"="https://www.sysinternals.com/"
>> tmp_install.reg ECHO "Publisher"="Microsoft Corporation"
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"


:End
@ECHO [END] %date%-%time%
EXIT
