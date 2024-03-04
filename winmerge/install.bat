
REM
REM   WinMerge
REM

REM Name
SET softname=WinMerge

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=__VERSION__


ECHO Silent install %softname%
ScriptRunner.exe -appvscript WinMerge-%softversion%-x64-Setup.exe /VERYSILENT /NORESTART /LOG="%logdir%\%softname%-MSI.log" -appvscriptrunnerparameters -wait -timeout=300


ECHO END %date%-%time%

IF %ERRORLEVEL% EQU 259 (
  ECHO 0 or 259 are good exit code for %softname% installer!
  EXIT 0
)
EXIT
