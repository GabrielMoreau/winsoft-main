# Windows11Update - Update Windows 10 or 11 to the last version of Windows 11

**Warning:** this package (script) has been tested on a few computers!
So far, it's worked every time, and compatible computers have ended up running Windows 11.
Don't run this script without warning the person...
It's much better if they don't work on the computer during the update.

To build the package, just type `make` in a terminal (preferably under Linux).

The Windows11Update package uses a DOS script `install.bat` to execute the `Windows11InstallationAssistant.exe` command.
This command installs the latest version of Windows 11 if the workstation is compatible.
The user has no interaction, however, at the end of the process, the workstation will not be rebooted automatically. 

```dos
Windows11InstallationAssistant.exe /QuietInstall /SkipEULA /NoRestartUI 
```

After the first reboot made by the user, Windows 11 will automatically reboot several times.

* Website : https://www.microsoft.com/software-download/windows11
* Wikipedia : https://en.wikipedia.org/wiki/Windows_11

* See Also : https://learn.microsoft.com/en-us/answers/questions/1020951/upgrading-w10-to-w11-with-windows11installationass?page=1#answer-1021082

If you want to make Windows 11 a little more secure, 
take a look at the dedicated tweaks (GPOs) on the [SWMB](https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb) website
(see [NEWS](https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb/-/blob/master/NEWS.md) file).
By the way, most of the keys useful for Windows 10 are still valid under Windows 11.
