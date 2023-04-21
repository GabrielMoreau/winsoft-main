REM @ECHO OFF

REM
REM   Wireshark
REM

REM Name
SET softname=Wireshark

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

REM NPCAP or Win10Pcap
SET softversion2=91.5.1

ECHO Silent install NPcap
REM npcap-%softversion2%.exe /S
msiexec /i Win10Pcap-v%softversion2%.msi ALLUSERS=1 /qn /L*v "%logdir%\%softname%-MSI2.log" 2>&1

ECHO Silent install %softname%
Wireshark-win64-%softversion%.exe /S


ECHO END %date%-%time%
EXIT
