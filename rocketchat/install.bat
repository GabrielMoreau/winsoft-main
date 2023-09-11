
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

SET softversion=__VERSION__
SET softpatch=__PATCH__
SET process=Rocket.Chat.exe


ECHO Kill the current process
VER | FIND /I "10.0" > NUL
IF %ERRORLEVEL%==0 TASKKILL /T /F /IM %process%

VER | FIND /I "6.1" > NUL
IF %ERRORLEVEL%==0 TASKKILL /T /F /IM %process%


ECHO Silent install %softname%
msiexec /q /i "rocketchat-%softversion%-win-x64.msi" ALLUSERS=1 /l*v "%logdir%\%softname%-MSI.log"


ECHO Push policies
IF EXIST "C:\Program Files\rocketchat\" (
  IF NOT EXIST "%ProgramFiles%\rocketchat\resources" MKDIR "%ProgramFiles%\rocketchat\resources"
  IF EXIST     "%ProgramFiles%\rocketchat\resources" COPY /A /Y servers.json "%ProgramFiles%\rocketchat\resources\servers.json"
)


ECHO END %date%-%time%
EXIT
