REM @ECHO OFF

REM
REM   AnyConnect
REM

REM Name
SET softname=AnyConnect

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=4.10.04071
SET softpatch=1


REM Silent install
msiexec /i "anyconnect-win-%softversion%-core-vpn-webdeploy-k9.msi" ALLUSERS=1 /qn /norestart /L*v "%logdir%\%softname%-MSI.log"


REM Default profile
IF NOT EXIST "%ProgramData%\Cisco" (
  MKDIR "%ProgramData%\Cisco"
)
IF NOT EXIST "%ProgramData%\Cisco\Cisco AnyConnect Secure Mobility Client" (
  MKDIR "%ProgramData%\Cisco\Cisco AnyConnect Secure Mobility Client"
)
IF NOT EXIST "%ProgramData%\Cisco\Cisco AnyConnect Secure Mobility Client\Profile" (
  MKDIR "%ProgramData%\Cisco\Cisco AnyConnect Secure Mobility Client\Profile"
)
COPY /B /Y "Profile_VPN_Default.xml" "%ProgramData%\Cisco\Cisco AnyConnect Secure Mobility Client\Profile\Profile_VPN_Default.xml"


ECHO END %date%-%time%
EXIT
