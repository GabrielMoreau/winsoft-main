
SET regkey=Xmind_is1
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Xmind.lnk
SET target=%ProgramFiles%\Xmind\Xmind.exe
SET process=Xmind.exe


ECHO Kill running process
TASKKILL /T /F /IM %process%


ECHO Silent uninstall previous version
IF EXIST "%ProgramFiles%\Xmind\Uninstall Xmind.exe" (
  ScriptRunner.exe -appvscript "%ProgramFiles%\Xmind\Uninstall Xmind.exe" /S -appvscriptrunnerparameters -wait -timeout=300
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
