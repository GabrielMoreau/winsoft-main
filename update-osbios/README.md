# OSBIOSUpdateNow (Action) - Force Windows and DELL/HP BIOS to update now

The OSBIOSUpdateNow package uses a DOS script to execute the
`wuauclt.exe` command (Windows 10) or `Windows11InstallationAssistant.exe`
(Windows 11), then attempts to update the BIOS. It then uses
the `dcu-cli.exe` (Dell Command | Update) executable on DELL-branded
machines, and the `HPImageAssistant.exe` (HPIA) program on HP-branded
computers.

Warning: this script does not update Windows 10 to Windows 11. You can
use the [Windows11Update](../windows11update/) package for that.

Example
```dos
REM Windows 10
wuauclt /detectnow /updatenow

REM Windows 11
Windows11InstallationAssistant.exe /QuietInstall /SkipEULA /NoRestartUI 
```

* See Also : https://www.minitool.com/backup-tips/windows-update-command-line-021.html,
	https://www.easeus.com/computer-instruction/force-update-windows-10.html,
	https://pureinfotech.com/install-windows-10-update-powershell/,
	https://learn.microsoft.com/en-us/answers/questions/1020951/upgrading-w10-to-w11-with-windows11installationass?page=1#answer-1021082
