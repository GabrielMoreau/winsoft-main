REM @ECHO OFF

REM Hide the Window
REM "cmdow.exe" @ /hid

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
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  ECHO Better reg uninstall key
   > tmp_install.reg ECHO Windows Registry Editor Version 5.00
  >> tmp_install.reg ECHO.
  >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
  >> tmp_install.reg ECHO "DisplayVersion"="%softversion%"
  >> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
  >> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS/%softpatch%)"
  >> tmp_install.reg ECHO.
  regedit.exe /S "tmp_install.reg"
)


ECHO END %date%-%time%
EXIT
