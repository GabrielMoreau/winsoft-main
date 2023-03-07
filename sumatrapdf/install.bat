REM @ECHO OFF

REM
REM   SumatraPDF
REM

REM Name
SET softname=SumatraPDF

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=3.4.1
SET softpatch=1


ECHO Silent install %softname%
SumatraPDF-%softversion%-64-install.exe -s -all-users -with-filter

ECHO Remove desktop link
IF EXIST "%ALLUSERSPROFILE%\Desktop\SumatraPDF.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\SumatraPDF.lnk"
IF EXIST "%ALLUSERSPROFILE%\Bureau\SumatraPDF.lnk"  DEL /F /Q "%ALLUSERSPROFILE%\Bureau\SumatraPDF.lnk"


ECHO END %date%-%time%
EXIT
