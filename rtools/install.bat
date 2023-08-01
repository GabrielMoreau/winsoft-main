REM @ECHO OFF

REM
REM   RTools
REM

REM Name
SET softname=RTools

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET SoftVersionS=__VERSION_S__
SET SoftVersionL=__VERSION_L__
SET SoftVersionV=__VERSION_V__
SET SoftPatch=__PATCH__
SET regkey=RTools
SET softpublisher=R Tools Team


ECHO Silent install R
R-%softversion2%-win.exe /VERYSILENT /NORESTART

ECHO Silent install %softname%
RTools-%SoftVersionL%.exe /S

ECHO Remove RTools if already exists
If EXIST "%SystemDrive%\rtools%SoftVersionS%\unins000.exe" "%SystemDrive%\rtools%SoftVersionS%\unins000.exe" /VERYSILENT /SUPPRESSMSGBOXES

ECHO Silent install RTools
rtools%SoftVersionL%.exe /VERYSILENT /SUPPRESSMSGBOXES /LOG="%logdir%\%softname%-MSI.log"

ECHO Change Add and Remove values in the register
 > tmp_install.reg ECHO Windows Registry Editor Version 5.00
>> tmp_install.reg ECHO.
>> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
>> tmp_install.reg ECHO "DisplayVersion"="%SoftVersionV%"
>> tmp_install.reg ECHO "Comments"="%softname% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
>> tmp_install.reg ECHO "DisplayName"="%softname% - %SoftVersionL%"
>> tmp_install.reg ECHO "InstallFolder"="%SystemDrive%\\rtools%SoftVersionS%"
>> tmp_install.reg ECHO "Publisher"="%softpublisher%"
>> tmp_install.reg ECHO "UninstallString"="%SystemDrive%\\rtools%SoftVersionS%\\unins000.exe"
>> tmp_install.reg ECHO "NoModify"=dword:00000001
>> tmp_install.reg ECHO "NoRepair"=dword:00000001
>> tmp_install.reg ECHO.
regedit.exe /S "tmp_install.reg"


ECHO END %date%-%time%
EXIT
