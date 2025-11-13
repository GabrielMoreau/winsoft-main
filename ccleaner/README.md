# CCleaner - Clean computer files and register keys

CCleaner developed by Piriform is a utility used to clean potentially
unwanted files and invalid Windows Registry entries from a computer.

* Website : https://www.ccleaner.com/
* Wikipedia : https://en.wikipedia.org/wiki/CCleaner

Be carreful, CCleaner Free and Professional are for home use only.
Use only on personnal computer.

* Download : https://www.ccleaner.com/ccleaner/download
* Silent install : https://silentinstallhq.com/ccleaner-silent-install-how-to-guide/,
  https://community.chocolatey.org/packages/ccleaner

```bat
.\ccsetup-VERSION.exe /S /L=1036
"%ProgramFiles%\CCleaner\uninst.exe" /S
```


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct   | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:------------ |:------------ |
 | HKLM | CCleaner    | Piriform  | 6.22           | `CCleaner`   | `"C:\Program Files\CCleaner\uninst.exe"` |
 | HKLM | CCleaner    | Piriform  | 6.33           | `CCleaner`   | `"C:\Program Files\CCleaner\uninst.exe"` |
 | HKLM | CCleaner 7  | Piriform  | 7.0.1010.1196  | `CCleaner 7` | `"C:\Program Files\Common Files\Piriform\Icarus\piriform-ccl\icarus.exe" /manual_update /uninstall:piriform-ccl` |
