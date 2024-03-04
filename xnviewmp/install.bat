
REM
REM   XnViewMP
REM

REM Name
SET softname=XnViewMP

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Silent Uninstall %softname% on 32-bit or 64-bit System
IF EXIST "%ProgramFiles%\XnView\unins000.exe"      ScriptRunner.exe -appvscript "%ProgramFiles%\XnView\unins000.exe"      /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300
IF EXIST "%ProgramFiles(x86)%\XnView\unins000.exe" ScriptRunner.exe -appvscript "%ProgramFiles(x86)%\XnView\unins000.exe" /VERYSILENT /NORESTART -appvscriptrunnerparameters -wait -timeout=300


ECHO Silent install %softname%
ScriptRunner.exe -appvscript XnViewMP-win-%softversion%-x64.exe /VERYSILENT /NORESTART /SUPPRESSMSGBOXES /MERGETASKS=!desktopicon /LOG="%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
