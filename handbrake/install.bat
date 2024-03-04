
REM
REM   HandBrake
REM

REM Name
SET softname=HandBrake

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION1__
SET softruntimever=__VERSION2__


Echo Silent install WindowsDesktop-Runtime
ScriptRunner.exe -appvscript windowsdesktop-runtime-%softruntimever%-win-x64.exe /install /quiet /norestart -appvscriptrunnerparameters -wait -timeout=300


Echo Silent install %softname%
ScriptRunner.exe -appvscript HandBrake-%softversion%-x86_64-Win_GUI.exe /S -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
