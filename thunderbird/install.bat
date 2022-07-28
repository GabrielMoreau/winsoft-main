REM @ECHO OFF
REM Hide the Window

REM "cmdow.exe" @ /hid

REM
REM   Thunderbird
REM

REM Name
SET softname=Mozilla Thunderbird

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
SET regkey=Mozilla Thunderbird (%softversion%)
SET process=thunderbird.exe


REM Kill the current process
TASKKILL /T /F /IM %process%


REM Silent install
REM "Thunderbird Setup %softversion%.exe" /MaintenanceService=false /S
msiexec /i "Thunderbird_Setup_%softversion%.msi" INSTALL_MAINTENANCE_SERVICE=false /q


REM Wait and remove unused service
ping 127.0.0.1 -n 2 > NUL
IF EXIST "c:\Program Files (x86)\Mozilla Thunderbird\uninstall\helper.exe" "c:\Program Files (x86)\Mozilla Thunderbird\uninstall\helper.exe" /S
ping 127.0.0.1 -n 2 > NUL
IF EXIST "c:\Program Files (x86)\Mozilla Maintenance Service\uninstall.exe" "c:\Program Files (x86)\Mozilla Maintenance Service\uninstall.exe" /S


REM Copy policies
IF NOT EXIST "C:\Program Files\Mozilla Thunderbird\distribution" MKDIR "C:\Program Files\Mozilla Thunderbird\distribution"
IF EXIST "C:\Program Files\Mozilla Thunderbird\distribution" COPY /y policies.json "C:\Program Files\Mozilla Thunderbird\distribution\policies.json" > NUL


REM Change Add and Remove values in the register
REM  > tmp_install.reg ECHO Windows Registry Editor Version 5.00
REM >> tmp_install.reg ECHO.
REM >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
REM >> tmp_install.reg ECHO "DisplayVersion"="%softversion% (fr)"
REM >> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
REM >> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS)"
REM >> tmp_install.reg ECHO.
REM regedit.exe /S "tmp_install.reg"



SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

REM add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

REM unblock
%pwrsh% "Unblock-File -Path .\*.ps1"

REM execute
%pwrsh% -File ".\post-install.ps1"


ECHO END %date%-%time%
EXIT
