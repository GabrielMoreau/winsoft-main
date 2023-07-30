REM @ECHO OFF

REM
REM   Avidemux
REM

REM Name
SET softname=Avidemux

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
avidemux-%softversion%-win64.exe /S

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Avidemux*.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Avidemux*.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Avidemux*.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Avidemux*.lnk"


ECHO END %date%-%time%

IF %ERRORLEVEL% EQU 1223 (
  ECHO 0 or 1223 are good exit code for %softname% installer!
  EXIT 0
)
EXIT
