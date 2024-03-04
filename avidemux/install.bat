
REM
REM   Avidemux
REM

REM Name
SET softname=Avidemux

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET softversionshort=__VERSIONSHORT__
SET regkey={0694d9fc-951c-4992-85e9-23eb6d1a8082}
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Avidemux.lnk


ECHO Silent install %softname%
REM ScriptRunner.exe -appvscript avidemux-%softversion%-win64.exe /S -appvscriptrunnerparameters -wait -timeout=300
ScriptRunner.exe -appvscript Avidemux_%softversion%.VC++.64bits.exe --script ".\avidemux.qs" -appvscriptrunnerparameters -wait -timeout=300


ECHO Copy avidemux.qs (need for silent uninstall)
IF EXIST "%ProgramFiles%\Avidemux %softversionshort% VC++ 64bits" COPY /A /Y "avidemux.qs" "%ProgramFiles%\Avidemux %softversionshort% VC++ 64bits"

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Avidemux*.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Avidemux*.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Avidemux*.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Avidemux*.lnk"


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Create shortcut
IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs" (
  %pwrsh% -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%shortcut%'); $SC.TargetPath = '%ProgramFiles%\Avidemux %softversionshort% VC++ 64bits\avidemux.exe'; $SC.Save();" -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile
  )


ECHO Better reg uninstall key
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
>> tmp_install.reg ECHO "Comments"="%softname%  (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="Avidemux VC++ 64bits"
>> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\Program Files\\Avidemux %softversionshort% VC++ 64bits\\uninstall.bat"
>> tmp_install.reg ECHO "InstallLocation"="%SystemDrive%\\Program Files\\Avidemux %softversionshort% VC++ 64bits"
>> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\Program Files\\Avidemux %softversionshort% VC++ 64bits"
>> tmp_install.reg ECHO "DisplayIcon"="%SystemDrive%\\Program Files\\Avidemux %softversionshort% VC++ 64bits\\avidemux.exe,0"
>> tmp_install.reg ECHO "URLInfoAbout"="https://github.com/mean00/avidemux2/"
>> tmp_install.reg ECHO "Publisher"="Mean"
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"

REM HKU	Avidemux VC++ 64bits	Mean	2.8.1	{0694d9fc-951c-4992-85e9-23eb6d1a8082}	C:\Program Files\Avidemux 2.8 VC++ 64bits\Uninstall Avidemux VC++ 64bits.exe
ECHO Clean reg uninstall key in HKU
REG QUERY "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% NEQ 0 GOTO Next
REG QUERY "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /v "UninstallString" | FIND /N "%SystemDrive%\\Program Files\\Avidemux %softversionshort% VC++ 64bits" > NUL && (
  ECHO REG DELETE HKU
  REG DELETE "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
  GOTO End
  )

:Next
ECHO Nice: no reg uninstall key in HKU
ECHO END %date%-%time%
EXIT 0


:End
ECHO END %date%-%time%
IF %ERRORLEVEL% EQU 1223 (
  ECHO 0 or 1223 are good exit code for %softname% installer!
  EXIT 0
)
EXIT
