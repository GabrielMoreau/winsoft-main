SETLOCAL

SET softname=Xmind
ECHO Begin pre-install script for %softname%

SET "installfolder=Xmind"
SET "regkey=Xmind_is1"
SET "shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Xmind.lnk"
SET "process=Xmind.exe"


ECHO Kill running process
TASKKILL /T /F /IM %process%


ECHO Silent uninstall previous version
IF EXIST "%ProgramFiles%\%installfolder%\Uninstall Xmind.exe" (
  ScriptRunner.exe -appvscript "%ProgramFiles%\%installfolder%\Uninstall Xmind.exe" /S -appvscriptrunnerparameters -wait -timeout=300
)

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
