REM @ECHO OFF

REM
REM   Zoom
REM

REM Name
SET softname=Zoom

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
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
msiexec /i ZoomInstallerFull-%softversion%.msi /quiet /qn /norestart /log "%logdir%\%softname%-MSI.log" MSIRESTARTMANAGERCONTROL="Disable" ZoomAutoUpdate="true" ZNoDesktopShortCut="true" ZSSOHOST="__ZSSOHOST__" ZConfig="nogoogle=1;nofacebook=1" ZRecommend="AudioAutoAdjust=1"


ECHO END %date%-%time%
EXIT
