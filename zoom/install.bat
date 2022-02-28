REM @ECHO OFF
REM Hide the Window

REM "cmdow.exe" @ /hid

REM
REM   Zoom
REM

REM Name
SET softname=Zoom

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL

REM https://support.zoom.us/hc/fr/articles/201362163-Installation-et-configuration-de-masse-pour-Windows

SET softversion=5.8.6
SET softpatch=1


REM Silent install
msiexec /i ZoomInstallerFull-$(VERSION).msi /quiet /qn /norestart /log c:\temp\zoommsi.log MSIRESTARTMANAGERCONTROL=”Disable” ZoomAutoUpdate="true" ZNoDesktopShortCut="true" ZSSOHOST="__ZSSOHOST__" ZConfig="nogoogle=1;nofacebook=1" ZRecommend="AudioAutoAdjust=1" 


EXIT
