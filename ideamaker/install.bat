
REM
REM   IdeaMaker
REM

REM Name
SET softname=IdeaMaker

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET regkey=ideaMaker


ECHO Silent install %softname%
ScriptRunner.exe -appvscript install_ideaMaker_%softversion%.exe /S -appvscriptrunnerparameters -wait -timeout=300


IF EXIST "%ProgramFiles%\Raise3D\ideaMaker\uninstall.exe" (
  ECHO Copy uninstall script
  COPY /A /Y "uninstall.bat" "%ProgramFiles%\Raise3D\ideaMaker\uninstall.bat"

  ECHO Better reg uninstall key
   > tmp_install.reg ECHO Windows Registry Editor Version 5.00
  >> tmp_install.reg ECHO.
  >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
  >> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
  >> tmp_install.reg ECHO "Comments"="%softname%  (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
  >> tmp_install.reg ECHO "DisplayName"="ideaMaker %softversion%"
  >> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files\\Raise3D\\ideaMaker\\uninstall.bat"
  >> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files\\Raise3D\\ideaMaker"
  >> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files\\Raise3D\\ideaMaker"
  >> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files\\Raise3D\\ideaMaker\\ideaMaker.exe,0"
  >> tmp_install.reg ECHO "URLInfoAbout"="https://www.raise3d.eu/"
  >> tmp_install.reg ECHO "Publisher"="Raise3D"
  >> tmp_install.reg ECHO.
  regedit.exe /S "tmp_install.reg"
)

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\ideaMaker.lnk"          DEL /F /Q "%PUBLIC%\Desktop\ideaMaker.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\ideaMaker.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\ideaMaker.lnk"



ECHO END %date%-%time%
EXIT
