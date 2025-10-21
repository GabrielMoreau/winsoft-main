
REM
REM   Uninstall-Xmind
REM

REM Name
SET softname=Uninstall-Xmind

SET logdir=%ProgramData%\OCS Inventory NG\Agent\DeployLog
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%

SET softversion=__VERSION__


ECHO Silent uninstall %softname%
CALL .\pre-install.bat


ECHO Auto Remove (last line)
ECHO END %date%-%time%
IF EXIST "%ProgramFiles%\Xmind" RMDIR /S /Q "%ProgramFiles%\Xmind"
