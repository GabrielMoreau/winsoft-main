
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


REM Silent install
ScriptRunner.exe -appvscript MsiExec.exe /i ZoomInstallerFull-%softversion%.msi /quiet /qn /norestart /log "%logdir%\%softname%-MSI.log" MSIRESTARTMANAGERCONTROL="Disable" ZoomAutoUpdate="true" ZNoDesktopShortCut="true" ZSSOHOST="__ZSSOHOST__" ZConfig="nogoogle=1;nofacebook=1" ZRecommend="AudioAutoAdjust=1" -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
