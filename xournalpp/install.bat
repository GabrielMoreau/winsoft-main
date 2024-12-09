
REM
REM   XournalPP
REM

REM Name
SET softname=XournalPP

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
REM SET regkey=Xournal++
REM SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Xournal++.lnk


ECHO Silent install %softname%
ScriptRunner.exe -appvscript xournalpp-%softversion%-windows-setup-x86_64.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /S /quiet -appvscriptrunnerparameters -wait -timeout=300
REM ScriptRunner.exe -appvscript xournalpp-%softversion%-windows.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /S /quiet -appvscriptrunnerparameters -wait -timeout=300


REM ECHO Copy uninstall script
REM COPY /A /Y "uninstall.bat" "%ProgramFiles%\%regkey%\uninstall.bat"


REM ECHO Search PowerShell
REM SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
REM IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

REM ECHO Create shortcut
REM IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs" (
REM   %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%shortcut%'); $SC.TargetPath = '%ProgramFiles%\%regkey%\bin\xournalpp.exe'; $SC.Save();" -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile
REM )


REM ECHO Better reg uninstall key
REM  > tmp_install.reg ECHO Windows Registry Editor Version 5.00
REM >> tmp_install.reg ECHO.
REM >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
REM >> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
REM >> tmp_install.reg ECHO "Comments"="%softname%  (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
REM >> tmp_install.reg ECHO "DisplayName"="%regkey% %softversion%"
REM >> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files\\%regkey%\\uninstall.bat"
REM >> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files\\%regkey%"
REM >> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files\\%regkey%"
REM >> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files\\%regkey%\\bin\\xournalpp.exe,0"
REM >> tmp_install.reg ECHO "URLInfoAbout"="https://github.com/xournalpp/xournalpp"
REM >> tmp_install.reg ECHO "Publisher"="Xournal Team"
REM >> tmp_install.reg ECHO.
REM regedit.exe /S "tmp_install.reg"


ECHO END %date%-%time%
EXIT
