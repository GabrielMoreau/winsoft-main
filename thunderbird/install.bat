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
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL

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
ping 127.0.0.1 -n 2 > nul
IF EXIST "c:\Program Files (x86)\Mozilla Thunderbird\uninstall\helper.exe" "c:\Program Files (x86)\Mozilla Thunderbird\uninstall\helper.exe" /S
ping 127.0.0.1 -n 2 > nul
IF EXIST "c:\Program Files (x86)\Mozilla Maintenance Service\uninstall.exe" "c:\Program Files (x86)\Mozilla Maintenance Service\uninstall.exe" /S


REM Copy policies
IF NOT EXIST "C:\Program Files\Mozilla Thunderbird\distribution" MKDIR "C:\Program Files\Mozilla Thunderbird\distribution"
IF  EXIST "C:\Program Files\Mozilla Thunderbird\distribution" COPY /y policies.json "C:\Program Files\Mozilla Thunderbird\distribution\policies.json" >NUL


REM Change Add and Remove values in the register
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%softversion% (fr)"
>> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS)"
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"


EXIT