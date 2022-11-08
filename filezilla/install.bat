REM @ECHO OFF

REM
REM   Filezilla
REM

REM Name
SET softname=FileZilla-Client

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

REM Version parameter (auto update by Makefile)
SET softversion=3.55.0
SET softpatch=7
SET softexe=FileZilla_%softversion%_win64-setup.exe

ECHO Uninstall previous version if exist
IF EXIST "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" (
  "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" /S
  "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" /S
)


ECHO Silent install
"%softexe%" /user=all /S


ECHO Disable welcome and check update
COPY /A /Y "fzdefaults.xml" "%ProgramFiles%\FileZilla FTP Client\fzdefaults.xml"


ECHO END %date%-%time%
EXIT
