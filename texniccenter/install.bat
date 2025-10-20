
REM
REM   TeXnicCenter
REM

REM Name
SET softname=TeXnicCenter

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Silent install %softname%
"TXCSetup_%softversion%Stable_x64.exe" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-

REM IF EXIST "%ProgramFiles%\TeXnicCenter\Language" COPY /Y fr_FR.aff "%ProgramFiles%\TeXnicCenter\Language"
REM IF EXIST "%ProgramFiles%\TeXnicCenter\Language" COPY /Y fr_FR.dic "%ProgramFiles%\TeXnicCenter\Language"
REM IF EXIST "%ProgramFiles(x86)%\TeXnicCenter\Language" COPY /Y fr_FR.aff "%ProgramFiles(x86)%\TeXnicCenter\Language"
REM IF EXIST "%ProgramFiles(x86)%\TeXnicCenter\Language" COPY /Y fr_FR.dic "%ProgramFiles(x86)%\TeXnicCenter\Language"




REM Change Add and Remove values in the register

REM > tmp_install.reg ECHO Windows Registry Editor Version 5.00
REM >> tmp_install.reg ECHO.
REM >> tmp_install.reg ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%regkey%]
REM >> tmp_install.reg ECHO "DisplayVersion"="%softversion% "
REM >> tmp_install.reg ECHO "Comments"="Package OCS v%softpatch% (%DATE:~-4%/%DATE:~-7,-5%/%DATE:~-10,-8%)"
REM >> tmp_install.reg ECHO "DisplayName"="%softname% (%softversion% OCS)"
REM >> tmp_install.reg ECHO.

REM regedit.exe /S "tmp_install.reg"


ECHO END %date%-%time%
EXIT
