REM @ECHO OFF
REM Hide the Window

REM "cmdow.exe" @ /hid

REM
REM   Inkscape
REM

REM Name
SET softname=Inkscape

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=91.5.1
SET softpatch=1
REM SET regkey=Inkscape (%softversion%)


REM Silent install
msiexec /i "inkscape-%softversion%-x64.msi" ALLUSERS=1 /qn


REM Change Add and Remove values in the register
REM > tmp_install.reg ECHO Windows Registry Editor Version 5.00
REM >> tmp_install.reg ECHO.
REM >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
REM >> tmp_install.reg ECHO "DisplayVersion"="%softversion% (fr)"
REM >> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
REM >> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS)"
REM >> tmp_install.reg ECHO.
REM regedit.exe /S "tmp_install.reg"


ECHO END %date%-%time%
EXIT
