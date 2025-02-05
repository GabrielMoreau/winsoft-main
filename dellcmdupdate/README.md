# Dell Command Update - Update BIOS and Firmware for Dell computer

Dell Command | Update is a stand-alone application, for commercial
client computers, that provides updates for system software that is
released by Dell. This application simplifies the BIOS, firmware, driver,
and application update experience for Dell commercial client hardware.

* Website : https://www.dell.com/

* Download : https://www.dell.com/support/home/en-us/drivers
* Silent install : https://silentinstallhq.com/dell-command-update-4-4-silent-install-how-to-guide/

You must have a serial number of a DELL machine to find the latest
version of the software on the DELL website. In principle, all DELL
computers use the same version of the software, so why isn't the
software freely downloadable with its version number clearly displayed?
That's another debate...

The search `DisplayName` key install the register is: `Dell Command | Update`
(it's pretty stupid to have put the pipe character in the full name of the software).


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Dell Command \| Update | Dell Inc. | 5.4.0 | `{AD1F63E4-F31F-48A2-BB8D-CF7B96CC46A0}` | `MsiExec.exe /X{AD1F63E4-F31F-48A2-BB8D-CF7B96CC46A0}` |
