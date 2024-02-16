
REM
REM   RocketChat
REM

REM Name
SET softname=RocketChat

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__
SET process=Rocket.Chat.exe


ECHO Kill the current process
TASKKILL /T /F /IM %process%


ECHO Search PowerShell
SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe

ECHO Add rights
%pwrsh% Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine

ECHO unblock
%pwrsh% "Unblock-File -Path .\*.ps1"


ECHO Execute pre-install script
%pwrsh% -File ".\pre-install.ps1" 1> "%logdir%\%softname%-PS1.log" 2>&1


ECHO Silent install %softname%
msiexec /q /i "rocketchat-%softversion%-win-x64.msi" ALLUSERS=1 /l*v "%logdir%\%softname%-MSI.log"


ECHO Push policies
IF EXIST "C:\Program Files\rocketchat\" (
  IF NOT EXIST "%ProgramFiles%\rocketchat\resources" MKDIR "%ProgramFiles%\rocketchat\resources"
  IF EXIST     "%ProgramFiles%\rocketchat\resources" COPY /A /Y servers.json "%ProgramFiles%\rocketchat\resources\servers.json"
)


ECHO Remove desktop shortcut
IF EXIST "%PUBLIC%\Desktop\Rocket.Chat.lnk"          DEL /F /Q "%PUBLIC%\Desktop\Rocket.Chat.lnk"
IF EXIST "%ALLUSERSPROFILE%\Desktop\Rocket.Chat.lnk" DEL /F /Q "%ALLUSERSPROFILE%\Desktop\Rocket.Chat.lnk"


ECHO END %date%-%time%
EXIT
