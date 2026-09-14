# TeraCopy - Reliable file copying, even when interrupted

TeraCopy is a file copy utility developed by Code Sector, an Australian software company.
It replaces the default Windows Explorer file transfer tool.
Imagine copying a 40 GB backup with 30,000 files.
One file is locked by another program. With the standard Windows tool, this can cause the whole operation to fail.
TeraCopy handles this differently.
It retries the problematic file several times.
If it still fails, TeraCopy skips it and continues copying the other files.
When the job is finished, TeraCopy shows you which files could not be copied.
You can then deal with these files separately.

* Website : https://codesector.com/teracopy
* Wikipedia : https://en.wikipedia.org/wiki/TeraCopy

* Download : https://codesector.com/downloads
* Silent install : https://silentinstallhq.com/teracopy-silent-install-how-to-guide/


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | TeraCopy | Code Sector | 4.0.3.2 | `{573E992C-480B-4636-9966-49162BC24D42}` | `MsiExec.exe /X{573E992C-480B-4636-9966-49162BC24D42}` |
