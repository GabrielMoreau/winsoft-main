
REM
REM   Zoom
REM

REM Name
SET softname=Zoom

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

REM https://support.zoom.us/hc/fr/articles/201362163-Installation-et-configuration-de-masse-pour-Windows

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


ECHO Silent install %softname%
ScriptRunner.exe -appvscript MsiExec.exe /i ZoomInstallerFull-%softversion%.msi /quiet /qn /norestart /log "%logdir%\%softname%-MSI.log" MSIRESTARTMANAGERCONTROL="Disable" ZoomAutoUpdate="true" ZNoDesktopShortCut="true" ZSSOHOST="__ZSSOHOST__" ZConfig="nogoogle=1;nofacebook=1" ZRecommend="AudioAutoAdjust=1" -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
