REM @ECHO OFF

REM
REM   WinMerge
REM

REM Name
SET softname=WinMerge

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


SET softversion=2.6.11
SET softpatch=1


ECHO Silent install %softname%
WinMerge-%softversion%-x64-Setup.exe /VERYSILENT /NORESTART /LOG="%logdir%\%softname%-MSI.log"


ECHO END %date%-%time%

IF %ERRORLEVEL% EQU 259 (
  ECHO 0 or 259 are good exit code for %softname% installer!
  EXIT 0
)
EXIT
