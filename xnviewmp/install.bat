REM @ECHO OFF

REM
REM   XnViewMP
REM

REM Name
SET softname=XnViewMP

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Silent Uninstall XnView on 32-bit or 64-bit System
IF EXIST "%ProgramFiles%\XnView\unins000.exe"      "%ProgramFiles%\XnView\unins000.exe"      /VERYSILENT /NORESTART
IF EXIST "%ProgramFiles(x86)%\XnView\unins000.exe" "%ProgramFiles(x86)%\XnView\unins000.exe" /VERYSILENT /NORESTART


ECHO Silent install %softname%
XnViewMP-win-%softversion%-x64.exe /VERYSILENT /NORESTART /SUPPRESSMSGBOXES /MERGETASKS=!desktopicon /LOG="%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%
EXIT
