# CCleaner - Clean computer files and register keys

CCleaner developed by Piriform is a utility used to clean potentially
unwanted files and invalid Windows Registry entries from a computer.

* Website : https://www.ccleaner.com/
* Wikipedia : https://en.wikipedia.org/wiki/CCleaner

Be carreful, CCleaner Free and Professional are for home use only.
Use only on personnal computer.

* Download : https://www.ccleaner.com/ccleaner/download
* Silent install : https://silentinstallhq.com/ccleaner-silent-install-how-to-guide/

```bat
.\ccsetup-VERSION.exe /S /L=1036
%ProgramFiles%\CCleaner\uninst.exe" /S
```

## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | CCleaner | Piriform | 6.22 | `CCleaner` | `"C:\Program Files\CCleaner\uninst.exe"` | 
