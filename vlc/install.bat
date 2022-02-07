REM @ECHO OFF

REM Hide the Window
REM "cmdow.exe" @ /hid

REM
REM   VLC
REM

REM Name
SET softname=VideoLAN VLC media player

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL

SET softversion=3.0.13
SET softpatch=1
SET regkey=VLC media player
SET process=vlc.exe


REM SET pwrsh=%WINDIR%\System32\WindowsPowerShell\V1.0\powershell.exe
REM IF EXIST "%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe" SET pwrsh=%WINDIR%\Sysnative\WindowsPowerShell\V1.0\powershell.exe


REM Silent install
"vlc-%softversion%-win64.exe" /S /NCRC


REM Better reg uninstall key
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%"
IF %ERRORLEVEL% EQU 0 (
  ECHO Better reg uninstall key
   > tmp_install.reg ECHO Windows Registry Editor Version 5.00
  >> tmp_install.reg ECHO.
  >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
  >> tmp_install.reg ECHO "DisplayVersion"="%softversion% (fr)"
  >> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
  >> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS/%softpatch%)"
  >> tmp_install.reg ECHO.
  regedit.exe /S "tmp_install.reg"
)
