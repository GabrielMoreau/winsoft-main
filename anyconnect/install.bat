
REM
REM   CiscoAnyConnect
REM

REM Name
SET softname=CiscoAnyConnect

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Stop VPN service version 4 and 5 (transition)
REM Get-Service -Name 'vpnagent'     # v4 / Cisco AnyConnect Secure Mobility Agent'
REM Get-Service -Name 'csc_vpnagent' # v5 / Cisco Secure Client - AnyConnect VP...
REM Get-Service -DisplayName 'Cisco AnyConnect Secure Mobility Agent'
NET STOP "vpnagent"
NET STOP "csc_vpnagent"


ECHO Silent install %softname%
REM ScriptRunner.exe -appvscript MsiExec.exe /i "anyconnect-win-%softversion%-core-vpn-webdeploy-k9.msi" ALLUSERS=1 /qn /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300
ScriptRunner.exe -appvscript MsiExec.exe /i "cisco-secure-client-win-%softversion%-core-vpn-webdeploy-k9.msi" ALLUSERS=1 /qn /norestart /L*v "%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


ECHO Copy default profile
IF NOT EXIST "%ProgramData%\Cisco\Cisco Secure Client\VPN\Profile" (
  MKDIR -p "%ProgramData%\Cisco\Cisco Secure Client\VPN\Profile"
)

ECHO Stop VPN service
NET STOP "csc_vpnagent"

ECHO Copy Profile
REM COPY /B /Y "Profile_VPN_Default.xml" "%ProgramData%\Cisco\Cisco AnyConnect Secure Mobility Client\Profile\Profile_VPN_Default.xml"
COPY /B /Y "Profile_VPN_Default.xml" "%ProgramData%\Cisco\Cisco Secure Client\VPN\Profile\Profile_VPN_Default.xml"

ECHO Start VPN service
NET START "csc_vpnagent"


ECHO END %date%-%time%
EXIT
