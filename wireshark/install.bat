
REM
REM   Wireshark
REM

REM Name
SET softname=Wireshark

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION1__

REM NPCAP or Win10Pcap
SET softversion2=__VERSION2__


ECHO Silent install NPcap or Win10Pcap
REM npcap-%softversion2%.exe /S;
IF NOT EXIST "%ProgramFiles%\Npcap\npcap.cat" (
  ECHO Silent install Win10Pcap
  ScriptRunner.exe -appvscript MsiExec.exe /i Win10Pcap-v%softversion2%.msi ALLUSERS=1 /qn /L*v "%logdir%\%softname%-MSI2.log" -appvscriptrunnerparameters -wait -timeout=300 2>&1 
)


ECHO Silent install %softname%
ScriptRunner.exe -appvscript Wireshark-%softversion%-x64.exe /S -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
