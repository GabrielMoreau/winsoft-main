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


SET softversion=
SET softpatch=1


REM download
miktexsetup_standalone.exe --verbose --local-package-repository=C:\temp\miktex --package-set=basic download

REM Silent install
miktexsetup_standalone.exe --verbose --local-package-repository=C:\temp\miktex --shared=yes --user-config="<APPDATA>\MiKTeX" --user-data="<LOCALAPPDATA>\MiKTeX" --user-install="<APPDATA>\MiKTeX" --package-set=basic install

REM wait before Remove
ping -n 31 127.0.0.1 -w 1000 > nul

REM remove localdownload
rmdir /S /Q "C:\temp\miktex"

ECHO END %date%-%time%
EXIT
