REM @ECHO OFF

REM
REM   FreeCAD
REM

REM Name
SET softname=FreeCAD

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET softpatch=__PATCH__


ECHO Silent install %softname%
FreeCAD-WIN-x64-installer-%softversion%.exe /S

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\FreeCAD*.lnk"          DEL /F /Q "%PUBLIC%\Desktop\FreeCAD*.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\FreeCAD*.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\FreeCAD*.lnk"


ECHO END %date%-%time%
EXIT
