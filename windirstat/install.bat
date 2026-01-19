
REM
REM   WinDirStat
REM

REM Name
SET softname=WinDirStat

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
REM SET regkey=windirstat
REM SET softexec=windirstat%softversion%_setup.exe
REM SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%softname%.lnk


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


REM Uninstall old version 1
IF EXIST "%ProgramFiles(x86)%\WinDirStat\Uninstall.exe" (
  "%ProgramFiles(x86)%\WinDirStat\Uninstall.exe"
)
REM Clean old reg uninstall key
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\windirstat"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\windirstat" /F
)
REM Clean old x86 folder
IF EXIST "%ProgramFiles(x86)%\WinDirStat" RMDIR /S /Q "%ProgramFiles(x86)%\WinDirStat"


ECHO Silent install %softname%
ScriptRunner.exe -appvscript MsiExec.exe /i WinDirStat-%softversion%-x64.msi /qn /norestart DESKTOP_SHORTCUT=0 STARTMENU_SHORTCUT=1 REBOOT=ReallySuppress /L*v "%logdir%\%softname%-MSI.log"  -appvscriptrunnerparameters -wait -timeout=300
SET RETURNCODE=%ERRORLEVEL%


:POSTINSTALL
ECHO Execute post-install script
%pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1
IF %RETURNCODE% EQU 0 SET RETURNCODE=%ERRORLEVEL%


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\%softname%.lnk"          DEL /F /Q "%PUBLIC%\Desktop\%softname%.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\%softname%.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\%softname%.lnk"


:END
ECHO END %date%-%time%
EXIT %RETURNCODE%
