
REM
REM   AcrobatReader
REM

REM Name
SET softname=AcrobatReader

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Execute pre-install script
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


ECHO Silent Install %softname%
ScriptRunner.exe -appvscript AcroRdrDCx64%softversion%_fr_FR.exe /sAll /rs /msi EULA_ACCEPT=YES DISABLEDESKTOPSHORTCUT=1 /L*V "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=600


ECHO Execute post-install script
%pwrsh% -File ".\post-install.ps1" 1>> "%logdir%\%softname%-PS1.log" 2>&1


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Adobe*Reader*.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Adobe*Reader*.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Adobe*Reader*.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Adobe*Reader*.lnk"
IF EXIST "%PUBLIC%\Desktop\Adobe*Acrobat.lnk"           DEL /F /Q "%PUBLIC%\Desktop\Adobe*Acrobat.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Adobe*Acrobat.lnk"  DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Adobe*Acrobat.lnk"


ECHO END %date%-%time%
EXIT
