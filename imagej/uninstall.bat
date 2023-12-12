ECHO OFF

SET regkey=ImageJ

REM Clean registry
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey% /f

REM Clean Start Menu
IF EXIST "%ProgramData%\Microsoft\Windows\Start Menu\Programs\ImageJ.lnk" DEL /F /Q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\ImageJ.lnk"

REM Clean the ImageJ folder
IF EXIST "%ProgramData%\ImageJ" RMDIR /S /Q "%ProgramData%\ImageJ"
