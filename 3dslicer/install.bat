REM @ECHO OFF

REM
REM   3DSlicer
REM

REM Name
SET softname=3DSlicer

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
Slicer-%softversion%-win-amd64.exe /S /D=%ProgramData%\Slicer.org


REM ECHO Remove desktop shortcut
REM IF EXIST "%PUBLIC%\Desktop\3DSlicer.lnk"          DEL /F /Q "%PUBLIC%\Desktop\3DSlicer.lnk"
REM IF EXIST "%ALLUSERSPROFILE%\Desktop\3DSlicer.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\3DSlicer.lnk"


ECHO END %date%-%time%
EXIT
