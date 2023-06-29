# OSBIOSUpdateNow - Force Windows and DELL/HP BIOS to update now

The OSBIOSUpdateNow package uses a DOS script to execute the
`wuauclt.exe` command, then attempts to update the BIOS. It then uses
the `dcu-cli.exe` (Dell Command | Update) executable on DELL-branded
machines, and the `HPImageAssistant.exe` (HPIA) program on HP-branded
computers.

Example
```dos
wuauclt /detectnow /updatenow
```

* See Also : https://www.minitool.com/backup-tips/windows-update-command-line-021.html,
	https://www.easeus.com/computer-instruction/force-update-windows-10.html,
	https://pureinfotech.com/install-windows-10-update-powershell/
