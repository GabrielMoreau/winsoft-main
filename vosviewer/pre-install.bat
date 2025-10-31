SETLOCAL

SET softname=VOSviewer
ECHO Begin pre-install script for %softname%

SET "installfolder=VOSviewer"
SET "regkey=VOSviewer_is1"
SET "shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\VOSviewer.lnk"
SET "process=VOSviewer.exe"


ECHO Kill running process
TASKKILL /T /F /IM %process%


ECHO Clean reg uninstall key
REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)
REG QUERY "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)


ECHO Remove Shortcut
IF EXIST "%shortcut%" DEL /F /Q "%shortcut%"
ENDLOCAL
