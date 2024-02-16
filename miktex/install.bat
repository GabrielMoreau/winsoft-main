REM @ECHO OFF

REM
REM   MiKTeX
REM

REM Name
SET softname=MiKTeX

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__


ECHO Download
miktexsetup-standalone-%softversion%.exe --verbose --local-package-repository=%SystemDrive%\Temp\MiKTeX --package-set=basic download

ECHO Silent install
miktexsetup-standalone-%softversion%.exe --verbose --local-package-repository=%SystemDrive%\Temp\MiKTeX --shared=yes --user-config="<APPDATA>\MiKTeX" --user-data="<LOCALAPPDATA>\MiKTeX" --user-install="<APPDATA>\MiKTeX" --package-set=basic install

ECHO Wait before Remove
ping -n 41 127.0.0.1 -w 1000 > nul

ECHO Remove localdownload
RMDIR /S /Q "%SystemDrive%\Temp\MiKTeX"


ECHO END %date%-%time%
EXIT
