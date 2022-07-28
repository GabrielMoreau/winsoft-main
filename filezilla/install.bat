REM @ECHO OFF

REM Hide the Window
REM "cmdow.exe" @ /hid

REM
REM   Filezilla
REM

REM Name
SET softname=FileZilla Client

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
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

reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  ECHO Better reg uninstall key
   > tmp_install.reg ECHO Windows Registry Editor Version 5.00
  >> tmp_install.reg ECHO.
  >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
  >> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
  >> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
  >> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS/%softpatch%)"
  >> tmp_install.reg ECHO.
  regedit.exe /S "tmp_install.reg"
)


ECHO END %date%-%time%
EXIT
