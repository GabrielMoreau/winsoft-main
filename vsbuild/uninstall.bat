
REM
REM   Uninstall-VSBuildTools
REM

REM Name
SET softname=Uninstall-VSBuildTools

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

@ECHO [BEGIN] %date%-%time%

SET softversion=__VERSION__


@ECHO [INFO] Silent uninstall %softname%
IF EXIST "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\setup.exe" (
  IF EXIST "%ProgramFiles(x86)%\Microsoft Visual Studio\18\BuildTools" START "" /WAIT "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\setup.exe" uninstall --installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\18\BuildTools" --quiet --norestart
)
IF EXIST "%ProgramFiles%\Microsoft Visual Studio\Installer\setup.exe" (
  IF EXIST "%ProgramFiles%\Microsoft Visual Studio\18\BuildTools" START "" /WAIT "%ProgramFiles%\Microsoft Visual Studio\Installer\setup.exe" uninstall --installPath "%ProgramFiles%\Microsoft Visual Studio\18\BuildTools" --quiet --norestart
)


@ECHO [END] %date%-%time%
EXIT
