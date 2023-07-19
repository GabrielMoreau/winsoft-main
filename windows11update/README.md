# Windows11Update - Update Windows 10 or 11 to the last version of Windows 11

**Warning:** this package (script) has never been tested!
For the moment, it's mainly a proof of concept.

The Windows11Update package uses a DOS script to execute the
`Windows11InstallationAssistant.exe` command.
This command installs the latest version of Windows 11 if the workstation
is compatible. The user has no interaction, however, at the end of the
process, the workstation will not be rebooted automatically. 

```dos
Windows11InstallationAssistant.exe /QuietInstall /SkipEULA /NoRestartUI 
```

After the first reboot made by the user, Windows 11 will automatically reboot several times.

* Website : https://www.microsoft.com/software-download/windows11
* Wikipedia : https://en.wikipedia.org/wiki/Windows_11

* See Also : https://learn.microsoft.com/en-us/answers/questions/1020951/upgrading-w10-to-w11-with-windows11installationass?page=1#answer-1021082