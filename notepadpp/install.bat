REM @ECHO OFF

REM
REM   Notepad++
REM

REM Name
SET softname=Notepad++

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

REM Version parameter (auto update by Makefile)
SET softversion=8.3
SET softexe=npp.%softversion%.Installer.x64.exe
SET softpatch=4
SET regkey=Notepad++


REM Kill running process
taskkill /IM notepad++.exe /F


REM Uninstall previous version
IF EXIST "%ProgramFiles%\Notepad++\uninstall.exe" (
  "%ProgramFiles%\Notepad++\uninstall.exe" /S
)

SET /A LOOPCOUNT=0 
:WAIT
SET /A LOOPCOUNT+=1
IF %LOOPCOUNT% GEQ 31 (
  ECHO Error: Too many loop before uninstall finish - Continue and cross our fingers!
  GOTO NEXT
)
ECHO Loop counter: %LOOPCOUNT%
ping 127.0.0.1 -n 6 > NUL
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 GOTO WAIT
reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 GOTO WAIT
ping 127.0.0.1 -n 3 > NUL

:NEXT

REM Silent install
"%softexe%" /S


REM Disable auto update
IF EXIST "%ProgramFiles%\Notepad++\updater_disable" (
  RMDIR /S /Q "%ProgramFiles%\Notepad++\updater_disable"
)
IF EXIST "%ProgramFiles%\Notepad++\updater" (
  RENAME "C:\%ProgramFiles%\Notepad++\updater" "updater_disable"
)

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
