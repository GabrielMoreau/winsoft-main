REM @ECHO OFF

REM Name
SET softname=PDFCreator
SET softversion=2.3.1
SET softpatch=1
SET regkey={0001B4FD-9EA3-4D90-A79E-FD14BA3AB01D}

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.txt" 2>&1
EXIT /B

:INSTALL


REM IF EXIST "%ProgramFiles%\PDFCreator\unins000.exe" "%ProgramFiles%\PDFCreator\unins000.exe" /verysilent
REM ping 127.0.0.1 -n 6 > NUL


REM SET regkey=FALSE
REM IF "%softversion%"=="0.9.3" SET regkey={0001B4FD-9EA3-4D90-A79E-FD14BA3AB01D}
REM IF "%softversion%"=="0.9.7" SET regkey={0001B4FD-9EA3-4D90-A79E-FD14BA3AB01D}
REM PDF Creator ne semble pas changer de clef...
REM SET regkey={0001B4FD-9EA3-4D90-A79E-FD14BA3AB01D}

REM Silent install
REM "PDFCreator-0.9.3.exe" /silent /sp- /NORESTART 
"PDFCreator-%softversion%-setup.exe" /verysilent /norestart /noicons /sp-

REM Change Add and Remove values in the register
REM IF NOT "%regkey%"=="FALSE" (
REM  > tmp_install.reg ECHO Windows Registry Editor Version 5.00
REM >> tmp_install.reg ECHO.
REM >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
REM >> tmp_install.reg ECHO "DisplayVersion"="%softversion% (fr)"
REM >> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
REM >> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS)"
REM >> tmp_install.reg ECHO.
REM regedit.exe /S "tmp_install.reg"
REM )

REM Program Menu
REM CD "%ALLUSERSPROFILE%\Menu*\Programmes"
REM MKDIR "Accessoires"
REM COPY /B /Y "%ALLUSERSPROFILE%\Bureau\PDFCreator.lnk" "Accessoires\PDFCreator - Manager.lnk"
REM DEL /F /Q "%ALLUSERSPROFILE%\Bureau\PDFCreator.lnk"

EXIT
