REM @ECHO OFF

REM
REM   Mikex
REM

REM Name
SET softname=Miktex

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=21.09
SET softpatch=1


ECHO Download
miktexsetup-standalone-%softversion%.exe --verbose --local-package-repository=%SystemDrive%\Temp\MiKTeX --package-set=basic download

ECHO Silent install
miktexsetup-standalone-%softversion%.exe --verbose --local-package-repository=%SystemDrive%\Temp\MiKTeX --shared=yes --user-config="<APPDATA>\MiKTeX" --user-data="<LOCALAPPDATA>\MiKTeX" --user-install="<APPDATA>\MiKTeX" --package-set=basic install

ECHO Wait before Remove
ping -n 31 127.0.0.1 -w 1000 > nul

ECHO Remove localdownload
RMDIR /S /Q "%SystemDrive%\Temp\MiKTeX"


ECHO END %date%-%time%
EXIT
