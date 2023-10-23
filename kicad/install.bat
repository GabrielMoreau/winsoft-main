
REM
REM   KiCad
REM

SET softname=KiCad

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
kicad-%softversion%-x86_64.exe /S


REM ECHO Remove desktop shortcut
REM IF EXIST "%PUBLIC%\Desktop\KiCad.lnk"          DEL /F /Q "%PUBLIC%\Desktop\KiCad.lnk"
REM IF EXIST "%ALLUSERSPROFILE%\Desktop\KiCad.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\KiCad.lnk"


ECHO END %date%-%time%
EXIT
