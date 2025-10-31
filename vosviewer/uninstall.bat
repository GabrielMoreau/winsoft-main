@ECHO OFF
SETLOCAL

SET softname=VOSviewer
ECHO Silent uninstall %softname%

SET "process=VOSviewer.exe"
SET "installfolder=VOSviewer"
SET "regkey=VOSviewer_is1"
SET "shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\VOSviewer.lnk"


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


ECHO Auto Remove (last line)
ECHO END %date%-%time%
IF EXIST "%ProgramFiles%\%installfolder%" RMDIR /S /Q "%ProgramFiles%\%installfolder%"
ENDLOCAL
