REM @ECHO OFF

REM
REM   WinMerge
REM

REM Name
SET softname=WinMerge

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=2.6.11
SET softpatch=1
REM SET regkey=WinMerge-%softversion%_is1
REM SET process=WinMergeU.exe

REM Kill the current process
REM VER | FIND /I "XP" > nul
REM IF %ERRORLEVEL%==0 TASKKILL /T /F /IM %process%


REM Silent install
WinMerge-%softversion%-x64-Setup.exe /VERYSILENT /NORESTART /LOG="%logdir%\%softname%-MSI.log"
REM "%softname%-%softversion%-Setup.exe" /VERYSILENT /SP- /NORESTART

REM Change Add and Remove values in the register
REM  > tmp_install.reg ECHO Windows Registry Editor Version 5.00
REM >> tmp_install.reg ECHO.
REM >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
REM >> tmp_install.reg ECHO "DisplayVersion"="%softversion% (fr)"
REM >> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
REM >> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS)"
REM >> tmp_install.reg ECHO.
REM regedit.exe /S "tmp_install.reg"


ECHO END %date%-%time%
EXIT
