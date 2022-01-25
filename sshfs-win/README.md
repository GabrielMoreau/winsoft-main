# SSHFS-Win - Connect network drive on an SSH/SFTP server

The script `sshfs-win-connect.ps1` simplfy the connexion for non advanced users.

You need a parameter file like [conf.sample.yml](conf.sample.yml) (without sample in the name) in the `winsoft-conf/sshfs-win` folder.
See the main [README](../README.md) file about the global configuration folder.

* `winfsp` - https://github.com/billziss-gh/winfsp.
  Il s'agit de la partie driver bas niveau jouant le rôle de Fuse.
* `sshfs-win` - https://github.com/billziss-gh/sshfs-win.
  C'est un ensemble de programme qui ajoute la couche SSH à ce pseudo Fuse.
* `sshfs-win-manager` - https://github.com/evsar3/sshfs-win-manager.
  Cette application elecktron s'installe dans le dossier de l'utilisateur
  et non pour tout le monde.
  Il faudrait partir du Zip
  et refaire un lien pour tous dans le menu démarré.
* `sirikali` - https://github.com/mhogomchungu/sirikali
  Cette GUI fait beaucoup de chose,
  mais du coup elle est assez (trop) complexe à utiliser par un utilisateur non averti.

```bash
wget https://github.com/billziss-gh/winfsp/releases/download/v1.10/winfsp-1.10.22006.msi
wget https://github.com/billziss-gh/sshfs-win/releases/download/v3.5.20357/sshfs-win-3.5.20357-x64.msi
wget https://github.com/evsar3/sshfs-win-manager/releases/download/v1.3.1/sshfs-win-manager-setup-v1.3.1.exe
wget https://github.com/mhogomchungu/sirikali/releases/download/1.4.8/SiriKali-1.4.8.setup.exe
```
