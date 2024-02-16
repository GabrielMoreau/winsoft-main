REM @ECHO OFF

REM
REM   Defraggler
REM

REM Name
SET softname=Defraggler

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__


ECHO Silent install %softname%
dfsetup%softversion%.exe /S

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Defraggler.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Defraggler.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Defraggler.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Defraggler.lnk"


ECHO END %date%-%time%
EXIT
