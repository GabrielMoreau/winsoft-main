
SET softname=PrusaSlicer
SET regkey=PrusaSlicer_is1
SET shortcut=%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\PrusaSlicer.lnk


REM HKLM	PrusaSlicer version 2.7.1	Prusa Research s.r.o.	2.7.1	PrusaSlicer_is1	"C:\Program Files\Prusa3D\PrusaSlicer\unins000.exe"	

REM Clean reg uninstall key
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%" /F
)

REM Remove Shortcut
IF EXIST "%shortcut%" DEL /F /Q "%shortcut%"
IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Prusa3D" RMDIR /S /Q "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Prusa3D"

REM Auto Remove (last line)
IF EXIST "%ProgramFiles%\Prusa3D\%softname%" RMDIR /S /Q "%ProgramFiles%\Prusa3D\%softname%"
