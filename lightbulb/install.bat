
REM
REM   LightBulb
REM

REM Name
SET softname=LightBulb

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
SET process=LightBulb.exe


ECHO Kill the current process
TASKKILL /T /F /IM LightBulb.exe /IM %process%


Echo Silent install WindowsDesktop-Runtime
ScriptRunner.exe -appvscript windowsdesktop-runtime-%softruntimever%-win-x64.exe /install /quiet /norestart -appvscriptrunnerparameters -wait -timeout=300


ECHO Silent install %softname%
ScriptRunner.exe -appvscript LightBulb-Installer-%softversion%-x64.exe /VERYSILENT /LOG="%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%
EXIT
