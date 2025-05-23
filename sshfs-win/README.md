# SSHFS-Win - Connect network drive on an SSH/SFTP server

SSHFS-Win is a free and open-source minimal port of SSHFS to Windows.
Under the hood it uses Cygwin for the POSIX environment and WinFsp
for the FUSE functionality.
Once you have installed WinFsp and SSHFS-Win you can map a network
drive to a directory on an SSHFS host using Windows Explorer or the
net use command.

* Website : https://github.com/billziss-gh/sshfs-win

The script `sshfs-win-connect.ps1` simplfy the connexion for non advanced users.
There is no need for an advanced graphical tool.

To build the package, you need a parameter file like
[conf.sample.yml](conf.sample.yml) (without sample in the name)
in the `winsoft-conf/sshfs-win` folder.
See the main [README](../README.md) file about the global configuration folder.

This tool use the two components:

* `winfsp` - https://github.com/billziss-gh/winfsp.
  Il s'agit de la partie driver bas niveau jouant le rôle de Fuse.
* `sshfs-win` - https://github.com/billziss-gh/sshfs-win.
  C'est un ensemble de programme qui ajoute la couche SSH à ce pseudo Fuse.

Users can use and configure SSHFS with these two graphical applications.
However, we found them unusable in their current state for our organization.

* `sshfs-win-manager` - https://github.com/evsar3/sshfs-win-manager.
  This elecktron application is installed in the user's folder, not for
  everyone. You'd have to start from the portable version (Zip) and
  create a shortcut for everyone in the start menu.
* `sirikali` - https://github.com/mhogomchungu/sirikali
  This graphic application does a lot of things, but at the same time
  it's rather (too) complex to use by an unsophisticated user.

```bash
wget https://github.com/billziss-gh/winfsp/releases/download/v1.10/winfsp-1.10.22006.msi
wget https://github.com/billziss-gh/sshfs-win/releases/download/v3.5.20357/sshfs-win-3.5.20357-x64.msi
wget https://github.com/evsar3/sshfs-win-manager/releases/download/v1.3.1/sshfs-win-manager-setup-v1.3.1.exe
wget https://github.com/mhogomchungu/sirikali/releases/download/1.4.8/SiriKali-1.4.8.setup.exe
```


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | SSHFS-Win 2021 (x64) | Navimatics LLC | 3.5.20357 | `{746A1587-C9D1-4026-97DB-058CF3952711}` | `MsiExec.exe /I{746A1587-C9D1-4026-97DB-058CF3952711}` |
 | HKU | SSHFS-Win Manager | Evandro Araujo | 1.3.1 | `b80d7a5d-eddb-5e4e-8e85-79b3a698e983` | `"C:\WINDOWS\system32\config\systemprofile\AppData\Local\Programs\sshfs-win-manager\Uninstall SSHFS-Win Manager.exe" /currentuser` |
 | HKLM | WinFsp 2023 | Navimatics LLC | 2.0.23075 | `{E4C768C9-0ED1-4E8D-9B05-CC533F7D1B1A}` | `MsiExec.exe /I{E4C768C9-0ED1-4E8D-9B05-CC533F7D1B1A}` |
