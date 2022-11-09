REM @ECHO OFF

REM
REM   VirtualBox
REM

REM Name
SET softname=VirtualBox

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=91.5.1
SET softpatch=1


REM Silent install
VirtualBox-%softversion%-Win.exe --silent --ignore-reboot

IF EXIST "%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" (
  echo y | "%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" extpack install --replace ".\Oracle-VM-VirtualBox-Extension-Pack-%softversion%.vbox-extpack"
)


ECHO END %date%-%time%
EXIT
