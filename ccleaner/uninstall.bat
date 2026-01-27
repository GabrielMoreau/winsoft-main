
REM
REM   Uninstall-CCleaner
REM

REM Name
SET softname=Uninstall-CCleaner

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%


IF EXIST "%ProgramFiles%\CCleaner\uninst.exe"      ScriptRunner.exe -appvscript "%ProgramFiles%\CCleaner\uninst.exe"      /S -appvscriptrunnerparameters -wait -timeout=300
IF EXIST "%ProgramFiles(x86)%\CCleaner\uninst.exe" ScriptRunner.exe -appvscript "%ProgramFiles(x86)%\CCleaner\uninst.exe" /S -appvscriptrunnerparameters -wait -timeout=300
IF EXIST "%ProgramFiles%\Common Files\Piriform\Icarus\piriform-ccl\icarus.exe" ScriptRunner.exe -appvscript "%ProgramFiles%\Common Files\Piriform\Icarus\piriform-ccl\icarus.exe" /manual_update /uninstall:piriform-ccl /silent -appvscriptrunnerparameters -wait -timeout=300


@ECHO [END] %date%-%time%
EXIT
