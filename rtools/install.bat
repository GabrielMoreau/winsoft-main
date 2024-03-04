
REM
REM   RTools
REM

REM Name
SET softname=RTools

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET SoftVersionS=__VERSION_S__
SET SoftVersionL=__VERSION_L__


ECHO Remove RTools if already exists
If EXIST "%SystemDrive%\rtools%SoftVersionS%\unins000.exe" ScriptRunner.exe -appvscript "%SystemDrive%\rtools%SoftVersionS%\unins000.exe" /VERYSILENT /SUPPRESSMSGBOXES -appvscriptrunnerparameters -wait -timeout=300


ECHO Silent install %softname%
ScriptRunner.exe -appvscript rtools%SoftVersionL%.exe /VERYSILENT /SUPPRESSMSGBOXES /LOG="%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
