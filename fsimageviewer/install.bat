REM @ECHO OFF

REM
REM   FastStoneImageViewer
REM

REM Name
SET softname=FastStoneImageViewer

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=91.5.1
SET softpatch=1


ECHO Silent install %softname%
FSViewerSetup-%softversion%.exe /S

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\FastStone Image Viewer.lnk"          DEL /F /Q "%PUBLIC%\Desktop\FastStone Image Viewer.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\FastStone Image Viewer.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\FastStone Image Viewer.lnk"


ECHO END %date%-%time%
EXIT
