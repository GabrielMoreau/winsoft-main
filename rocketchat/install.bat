REM @ECHO OFF

REM
REM   RocketChat
REM

REM Name
SET softname=RocketChat

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=3.9.5
SET softpatch=1
SET process=Rocket.Chat.exe


REM Kill the current process
VER | FIND /I "10.0" > NUL
IF %ERRORLEVEL%==0 TASKKILL /T /F /IM %process%

VER | FIND /I "6.1" > NUL
IF %ERRORLEVEL%==0 TASKKILL /T /F /IM %process%


REM Silent install
msiexec.exe /q /i "rocketchat-%softversion%-win-x64.msi" ALLUSERS=1 /l*v "%logdir%\%softname%-MSI.log"

ECHO Push policies
IF EXIST "C:\Program Files\rocketchat\" (
  IF NOT EXIST "C:\Program Files\rocketchat\resources" MKDIR "C:\Program Files\rocketchat\resources"
  IF EXIST "C:\Program Files\rocketchat\resources" COPY /y servers.json "C:\Program Files\rocketrhat\resources\servers.json" > NUL
)

ECHO END %date%-%time%
EXIT
