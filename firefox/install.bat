@ECHO OFF

REM Hide the Window

"cmdow.exe" @ /hid

SET softversion=91.5.1
SET softpatch=1
SET softname=Mozilla Firefox
SET process=firefox.exe


REM Kill the current process

VER | FIND /I "10.0" > nul
IF %ERRORLEVEL%==0 TASKKILL /T /F /IM %process%

VER | FIND /I "6.1" > nul
IF %ERRORLEVEL%==0 TASKKILL /T /F /IM %process%


REM "Firefox Setup %softversion%esr.exe" -ms
msiexec /i "Firefox Setup %softversion%esr.msi" INSTALL_MAINTENANCE_SERVICE=false /q

REM voir https://github.com/mozilla/policy-templates/blob/master/README.md
IF NOT EXIST "C:\Program Files\Mozilla Firefox\distribution" MKDIR "C:\Program Files\Mozilla Firefox\distribution"
IF  EXIST "C:\Program Files\Mozilla Firefox\distribution" COPY /y policies.json "C:\Program Files\Mozilla Firefox\distribution\policies.json" >NUL


REM IF EXIST "C:\Program Files (x86)\Mozilla Firefox\" COPY /y local-settings.js "C:\Program Files (x86)\Mozilla Firefox\defaults\pref" >NUL
REM IF EXIST "C:\Program Files (x86)\Mozilla Firefox\" COPY /y mozilla.cfg "C:\Program Files (x86)\Mozilla Firefox\mozilla.cfg" >NUL

REM IF EXIST "C:\Program Files\Mozilla Firefox\" COPY /y local-settings.js "C:\Program Files\Mozilla Firefox\defaults\pref" >NUL
REM IF EXIST "C:\Program Files\Mozilla Firefox\" COPY /y mozilla.cfg "C:\Program Files\Mozilla Firefox\mozilla.cfg" >NUL


EXIT
