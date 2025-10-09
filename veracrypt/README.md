# VeraCrypt - Crypt disk and volume (USK key)

VeraCrypt is a free and open-source utility for on-the-fly encryption (OTFE).
The software can create a virtual encrypted disk that works just like a
regular disk but within a file. It can also encrypt a partition or
(in Windows) the entire storage device with pre-boot authentication.

* Website : https://veracrypt.fr/
* Wikipedia : https://en.wikipedia.org/wiki/VeraCrypt

* Download : https://www.veracrypt.fr/en/Downloads.html
* Silent install : https://silentinstallhq.com/veracrypt-silent-install-how-to-guide/

Warning: despite the command-line parameters, the installation may put a link on the desktop and reboot the computer.
It depends on the version...
Be sure to check on a few workstations before deploying intensively across your entire IT estate.


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | VeraCrypt 1.26.14 | IDRIX     | 1.26.14 | `{7207FED4-7243-4657-A542-60A50F2B722F}` | `MsiExec.exe /X{7207FED4-7243-4657-A542-60A50F2B722F}` |
 | HKLM | VeraCrypt 1.26.24 | AM Crypto | 1.26.24 | `{9EBED8F8-BD2F-4561-B5A3-628A8815F51F}` | `MsiExec.exe /X{9EBED8F8-BD2F-4561-B5A3-628A8815F51F}` |
