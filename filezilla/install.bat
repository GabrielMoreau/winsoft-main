REM @ECHO OFF

REM
REM   Filezilla
REM

REM Name
SET softname=FileZilla Client

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
SET regkey=FileZilla Client

ECHO Uninstall previous version if exist
IF EXIST "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" (
  "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" /S
  "%ProgramFiles%\FileZilla FTP Client\uninstall.exe" /S
)


ECHO Silent install
"%softexe%" /user=all /S


ECHO Disable welcome and check update
COPY /A /Y "fzdefaults.xml" "%ProgramFiles%\FileZilla FTP Client\fzdefaults.xml"

REM reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
REM IF %ERRORLEVEL% EQU 0 (
REM   ECHO Better reg uninstall key
REM    > tmp_install.reg ECHO Windows Registry Editor Version 5.00
REM   >> tmp_install.reg ECHO.
REM   >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
REM   >> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
REM   >> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
REM   >> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS/%softpatch%)"
REM   >> tmp_install.reg ECHO.
REM   regedit.exe /S "tmp_install.reg"
REM )


ECHO END %date%-%time%
EXIT
