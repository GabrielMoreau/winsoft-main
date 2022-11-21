REM @ECHO OFF

REM
REM   KeepassXC
REM

REM Name
SET softname=KeepassXC

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=2.7.1
SET softpatch=1
SET process=KeepassXC.exe


REM Kill the current process
VER | FIND /I "10.0" > NUL
IF %ERRORLEVEL%==0 TASKKILL /T /F /IM %process%

VER | FIND /I "6.1" > NUL
IF %ERRORLEVEL%==0 TASKKILL /T /F /IM %process%


REM Silent install
REM https://keepassxc.org/docs/KeePassXC_GettingStarted.html
msiexec.exe /q /i "KeePassXC-%softversion%-Win64.msi" AUTOSTARTPROGRAM=0 LAUNCHAPPONEXIT=0 

ECHO END %date%-%time%
EXIT
