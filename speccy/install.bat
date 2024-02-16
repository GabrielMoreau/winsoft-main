REM @ECHO OFF

REM
REM   Speccy
REM

REM Name
SET softname=Speccy

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
spsetup%softversion%.exe /S

ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Speccy.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Speccy.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Speccy.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Speccy.lnk"


ECHO END %date%-%time%
EXIT
