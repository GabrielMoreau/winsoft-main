REM @ECHO OFF

REM
REM   VLC
REM

REM Name
SET softname=WinDirStat

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=1.1.2
SET softpatch=1
SET regkey=windirstat
SET softexec=windirstat%softversion%_setup.exe


REM Silent install
"%softexec%" /S


REM Better reg uninstall key
REM reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
REM IF %ERRORLEVEL% EQU 0 (
REM   ECHO Better reg uninstall key
REM    > tmp_install.reg ECHO Windows Registry Editor Version 5.00
REM   >> tmp_install.reg ECHO.
REM   >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
REM   >> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
REM   >> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
REM   >> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS/%softpatch%)"
REM   >> tmp_install.reg ECHO.
REM   regedit.exe /S "tmp_install.reg"
REM )


ECHO END %date%-%time%
EXIT
