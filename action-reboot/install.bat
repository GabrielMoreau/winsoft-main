
REM
REM   Action-Reboot
REM

REM Name
SET softname=Action-Reboot

SET logdir=__LOGDIR__
IF NOT EXIST "%logdir%" (
  MKDIR "%logdir%"
)
CALL :INSTALL 1> "%logdir%\%softname%.log" 2>&1
EXIT /B

:INSTALL

ECHO BEGIN %date%-%time%


shutdown /r /t 300 /c "Force Reboot by __IT_TEAM__"


ECHO END %date%-%time%
EXIT
