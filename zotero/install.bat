REM @ECHO OFF

REM
REM   Zotero
REM

REM Name
SET softname=Zotero

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
Zotero-%softversion%_setup.exe /S


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\%softname%.lnk"          DEL /F /Q "%PUBLIC%\Desktop\%softname%.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\%softname%.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\%softname%.lnk"


ECHO END %date%-%time%
EXIT
