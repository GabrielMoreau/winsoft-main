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


ECHO Stop VPN service
REM Get-Service -Name 'vpnagent'
REM Get-Service -DisplayName 'Cisco AnyConnect Secure Mobility Agent'
NET STOP "vpnagent"

ECHO Silent install %softname%
msiexec /i "anyconnect-win-%softversion%-core-vpn-webdeploy-k9.msi" ALLUSERS=1 /qn /norestart /L*v "%logdir%\%softname%-MSI.log"


ECHO Copy default profile
IF NOT EXIST "%ProgramData%\Cisco" (
  MKDIR "%ProgramData%\Cisco"
)
IF NOT EXIST "%ProgramData%\Cisco\Cisco AnyConnect Secure Mobility Client" (
  MKDIR "%ProgramData%\Cisco\Cisco AnyConnect Secure Mobility Client"
)
IF NOT EXIST "%ProgramData%\Cisco\Cisco AnyConnect Secure Mobility Client\Profile" (
  MKDIR "%ProgramData%\Cisco\Cisco AnyConnect Secure Mobility Client\Profile"
)

ECHO Stop VPN service
NET STOP "vpnagent"

ECHO Copy Profile
COPY /B /Y "Profile_VPN_Default.xml" "%ProgramData%\Cisco\Cisco AnyConnect Secure Mobility Client\Profile\Profile_VPN_Default.xml"

ECHO Start VPN service
NET START "vpnagent"


ECHO END %date%-%time%
EXIT
