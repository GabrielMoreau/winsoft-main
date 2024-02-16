REM @ECHO OFF

REM
REM   Nextcloud
REM

REM Name
SET softname=Nextcloud

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


REM Silent install
msiexec /i Nextcloud-%softversion%-x64.msi REBOOT=ReallySuppress /qn


ECHO END %date%-%time%
EXIT
