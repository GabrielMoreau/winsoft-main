# WinSoft-Main - Windows AutoBuild Silent Package Software

WinSoft is the acronym for Windows Software.
WinSoft-Main helps you create packages
(Zip archives with a built-in silent installer)
of the latest versions of many standard Windows software. 
A better name could be Windows AutoBuild Silent Package Software.
The main repository contains the most common software packages,
and you can (and should) associate it with a conf repository containing
the configuration related to your site.
This is only useful for certain packages.

## Package structure

Each folder (except the common folder) contains a piece of software
(or a coherent set of software) that is useful to users.
In each folder there is a `Makefile` which will build the OCS Inventory
package which is just a Zip archive.
Inside this archive, the DOS script `install.bat` starts the
installation process, or uninstallation if it is an obsolete software
package with `uninstall` in its name.
There are sometimes `pre-install.ps1` and `post-install.ps1` scripts
written in PowerShell.

With a little work, it would be quite easy to transform these Zip
archives into WAPT, or PDQ Deploy packages.

```bash
make
make ocs
```

You just have to put this Zip package on your server.
The command to run for the installation is always `install.bat`.

## Master Target

A master `Makefile` at the root of the project allows all packages to
be built automatically. It is possible to put a `.noauto` file in each
folder to avoid this construction.
There are other possible targets. Look at the `Makefile` source.

* `build-all`  build all package except if `.noauto` file
* `clean-all`  clean all package except if `.noauto` file
* `list-pkg`   list all package
* `space`      clean old package

## Configuration

However, some packages need some parameters.
These parameters depend on your site.
So, in addition to the `winsoft-main` folder, you should have a `winsoft-conf` folder.
The `Makefile` will fetch the settings from a file in this folder.
There is an example file in the package in which a setting is needed.

To find out which parameters you can adapt to your site, the `common`
folder, whose main file is `global.mk`, lists these parameters with
default values (which don't always work).

## How it works

Most of the downloads use the `curl` tool and not `wget`,
this allows to have the scripts running under GNU/Linux and MacOSX environments.
Indeed, the packages are currently all built under these environments
to facilitate automation.

Note the optional use of the `peres` tool (Debian `pev` package)
which allows to retrieve the version number in a `setup.exe` installation file.
If this tool is available, a version number check is performed.

Unfortunately, many installation programs `setup.exe` have no version
number (Product Version). This is a pity, as there is sometimes some
doubt as to the actual version of a program.

Similarly, some MSI packages have the version number in the comment or
subject line, but not all. It is therefore difficult to always validate
this version number. We can sometime use `msiextract` to extract an
`.exe` file and then use `peres` on it!
Please devops, put always the version number clearly in the comment...

```bash
apt install make curl wget pev msitools
```

## List of 83 packages

 | Software | Detail | &#127968; | © |
 | -------- | ------ | --------- | - |
 | [7-Zip](7zip/README.md) | File archiver with a high compression ratio | [&#127968;](https://www.7-zip.org/) | ![](./common/img/lic-copyleft.svg) |
 | [AcrobatReader](acrobatreader/README.md) | Adobe PDF reader | [&#127968;](https://www.adobe.com/) | ![](./common/img/lic-copyright.svg) |
 | [AnyConnect](anyconnect/README.md) | Cisco AnyConnect VPN | [&#127968;](https://www.cisco.com/c/en/us/security/vpn-endpoint-security-clients/) | ![](./common/img/lic-copyright.svg) |
 | [Arduino IDE](arduinoide/README.md) | Integrated Development Environment for Arduino | [&#127968;](https://www.arduino.cc/) | ![](./common/img/lic-copyleft.svg) |
 | [Audacity](audacity/README.md) | Digital Audio Editor | [&#127968;](https://wiki.audacityteam.org/wiki/Audacity_Wiki_Home_Page) | ![](./common/img/lic-copyleft.svg) |
 | [Avidemux](avidemux/README.md) | Vector graphics editor | [&#127968;](http://fixounet.free.fr/avidemux/) | ![](./common/img/lic-copyleft.svg) |
 | [Balena Etcher](balenaetcher/README.md) | Flash OS images to SD cards & USB drives, safely and easily | [&#127968;](https://etcher.balena.io/) | ![](./common/img/lic-copyright.svg) |
 | [Bandicut](bandicut/README.md) | Join and cut video | [&#127968;](https://www.bandicam.com/bandicut-video-cutter/) | ![](./common/img/lic-copyright.svg) |
 | [Bitvise SSH Client](bvsshclient/README.md) | Graphical SSH client | [&#127968;](https://www.bitvise.com/) | ![](./common/img/lic-copyright.svg) |
 | [BleachBit](bleachbit/README.md) | Clean computer files and privacy manager | [&#127968;](https://www.bleachbit.org/) | ![](./common/img/lic-copyleft.svg) |
 | [Blender](blender/README.md) | 3D computer graphics software (animated films, virtual reality) | [&#127968;](https://www.blender.org/) | ![](./common/img/lic-copyleft.svg) |
 | [BlueKenue](bluekenue/README.md) | Tool for hydraulic modellers | [&#127968;](https://nrc.canada.ca/fr/recherche-developpement/produits-services/logiciels-applications/blue-kenuetm-logiciel-modelisateurs-hydrauliques) | ![](./common/img/lic-copyright.svg) |
 | [CCleaner](ccleaner/README.md) | Clean computer files and register keys | [&#127968;](https://www.ccleaner.com/) | ![](./common/img/lic-copyright.svg) |
 | [Chrome](chrome/README.md) | Google Chrome navigator | [&#127968;](https://www.google.com/chrome/) | ![](./common/img/lic-copyright.svg) |
 | [CitrixWorkspace](citrixworkspace/README.md) | Citrix remote workspace client | [&#127968;](https://www.citrix.com/) | ![](./common/img/lic-copyright.svg) |
 | [Darktable](darktable/README.md) | Photography application and raw developer | [&#127968;](https://www.darktable.org/) | ![](./common/img/lic-copyleft.svg) |
 | [Defraggler](defraggler/README.md) | Hard disk defragmentation utility | [&#127968;](https://www.ccleaner.com/defraggler) | ![](./common/img/lic-copyright.svg) |
 | [Dell Command Update](dellcmdupdate/README.md) | Update BIOS and Firmware for Dell computer | [&#127968;](https://www.dell.com/) | ![](./common/img/lic-copyright.svg) |
 | [Digikam](digikam/README.md) | Image organizer and tag editor  | [&#127968;](https://www.digikam.org/) | ![](./common/img/lic-copyright.svg) |
 | [Engauge Digitizer](engaugedigitizer/README.md) | Digitalize curve image to data point | [&#127968;](https://markummitchell.github.io/engauge-digitizer/) | ![](./common/img/lic-copyright.svg) |
 | [FastStone Image Viewer](fsimageviewer/README.md) | Image browser, converter and editor | [&#127968;](https://www.faststone.org/) | ![](./common/img/lic-copyright.svg) |
 | [FileZilla](filezilla/README.md) | Graphical two panel FTP/SFTP client | [&#127968;](https://filezilla-project.org/) | ![](./common/img/lic-copyleft.svg) |
 | [FlashPlayer (Uninstall)](flashplayer-uninstall/README.md) | Remove all version of Adobe Flash Player | [&#127968;](https://www.adobe.com/products/flashplayer/end-of-life.html) | ![](./common/img/lic-copyright.svg) |
 | [FreeCAD](freecad/README.md) | Parametric 3D modeler (CAD) | [&#127968;](https://www.freecad.org/) | ![](./common/img/lic-copyleft.svg) |
 | [Gimp](gimp/README.md) | Image graphics editor | [&#127968;](https://www.gimp.org/) | ![](./common/img/lic-copyleft.svg) |
 | [GitForWindows](gitforwindows/README.md) | Git for the Windows OS | [&#127968;](https://gitforwindows.org/) | ![](./common/img/lic-copyright.svg) |
 | [Gwyddion](gwyddion/README.md) | Data visualization and analysis for SPM | [&#127968;](http://gwyddion.net/) | ![](./common/img/lic-copyright.svg) |
 | [HandBrake](handbrake/README.md) | Video converter | [&#127968;](https://handbrake.fr/) | ![](./common/img/lic-copyleft.svg) |
 | [HP Image Assistant](hpimageassist/README.md) | Assistance to IT System Administrators (HPIA) for HP computer | [&#127968;](https://www.hp.com/us-en/solutions/client-management-solutions.html) | ![](./common/img/lic-copyright.svg) |
 | [HP Support Assistant](hpsupportassist/README.md) | Assist for computer maintenance, software upgrades, troubleshooting problems | [&#127968;](https://support.hp.com/us-en/help/hp-support-assistant) | ![](./common/img/lic-copyright.svg) |
 | [ImageJ](imagej/README.md) | Image processing program (Fiji Distribution) | [&#127968;](https://imagej.net/) | ![](./common/img/lic-copyleft.svg) |
 | [Inkscape](inkscape/README.md) | Vector graphics editor | [&#127968;](https://inkscape.org/) | ![](./common/img/lic-copyleft.svg) |
 | [Kaspersky Endpoint (Uninstall)](kaspersky-uninstall/README.md) | Silent remove Kaspersky Endpoint | [&#127968;](https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb/-/tree/master/dists/uninstall-kaspersky) | ![](./common/img/lic-copyright.svg) |
 | [KeepassXC](keepassxc/README.md) | Free and open-source password manager. | [&#127968;](https://keepassxc.org/) | ![](./common/img/lic-copyleft.svg) |
 | [LibreOffice](libreoffice/README.md) | Libre Office suite based on the OpenDocument standard | [&#127968;](https://www.libreoffice.org/) | ![](./common/img/lic-copyleft.svg) |
 | [LightBulb](lightbulb/README.md) | Automatically adjusts screen gamma and color temperature during the day | [&#127968;](https://github.com/Tyrrrz/LightBulb) | ![](./common/img/lic-copyright.svg) |
 | [MiKTeX](miktex/README.md) | TeX and LaTeX distribution | [&#127968;](https://miktex.org/) | ![](./common/img/lic-copyleft.svg) |
 | [Mozilla Firefox](firefox/README.md) | Web navigator | [&#127968;](https://www.mozilla.org) | ![](./common/img/lic-copyleft.svg) |
 | [Mozilla Thunderbird](thunderbird/README.md) | Mail reader | [&#127968;](https://www.thunderbird.net/) | ![](./common/img/lic-copyleft.svg) |
 | [MSEdge](msedge/README.md) | Microsoft Edge (Chrome) navigator | [&#127968;](https://www.microsoft.com/en-us/edge/business) | ![](./common/img/lic-copyright.svg) |
 | [MSTeams](teams/README.md) | Microsoft Videoconferencing and communication platform | [&#127968;](https://www.microsoft.com/fr-fr/microsoft-teams/) | ![](./common/img/lic-copyright.svg) |
 | [Nextcloud](nextcloud/README.md) | Cloud Suite agent | [&#127968;](https://nextcloud.com/) | ![](./common/img/lic-copyleft.svg) |
 | [Notepad++](notepadpp/README.md) | Text editor | [&#127968;](https://notepad-plus-plus.org) | ![](./common/img/lic-copyright.svg) |
 | [OBS Studio](obsstudio/README.md) | Screencasting and streaming application | [&#127968;](https://obsproject.com/) | ![](./common/img/lic-copyleft.svg) |
 | [OCSInventory-Agent](ocsinventory-agent/README.md) | Windows Agent for OCS-Inventory | [&#127968;](https://ocsinventory-ng.org) | ![](./common/img/lic-copyleft.svg) |
 | [OpenShot](openshot/README.md) | Open-source video editor | [&#127968;](https://www.openshot.org/) | ![](./common/img/lic-copyleft.svg) |
 | [OSBIOSUpdateNow (Action)](osbiosupdatenow/README.md) | Force Windows and DELL/HP BIOS to update now |  | ![](./common/img/lic-copyright.svg) |
 | [ParaView](paraview/README.md) | Vector graphics editor | [&#127968;](https://www.paraview.org/) | ![](./common/img/lic-copyleft.svg) |
 | [PDFCreator](pdfcreator/README.md) | Create PDF file | [&#127968;](https://www.pdfforge.org/) | ![](./common/img/lic-copyright.svg) |
 | [PDFsam Basic](pdfsam/README.md) | Split, merge, extract PDF files | [&#127968;](https://pdfsam.org/) | ![](./common/img/lic-copyleft.svg) |
 | [PuTTY](putty/README.md) | SSH Client | [&#127968;](https://www.chiark.greenend.org.uk/~sgtatham/putty/) | ![](./common/img/lic-copyleft.svg) |
 | [Recuva](recuva/README.md) | Recovers files on Windows computer | [&#127968;](https://www.ccleaner.com/recuva) | ![](./common/img/lic-copyright.svg) |
 | [RocketChat](rocketchat/README.md) | Chat desktop client for RocketChat servers | [&#127968;](https://www.rocket.chat/) | ![](./common/img/lic-copyleft.svg) |
 | [RStudio](rstudio/README.md) | Integrated development environment for R (include R) | [&#127968;](https://github.com/rstudio/rstudio,) | ![](./common/img/lic-copyleft.svg) |
 | [RTools](rtools/README.md) | Extend R language from source packages | [&#127968;](https://cran.r-project.org/bin/windows/Rtools/) | ![](./common/img/lic-copyright.svg) |
 | [SimpleTruss](simpletruss/README.md) | Drawing and calculating simple lattices | [&#127968;](http://www.apartmina.cz/simpletruss/) | ![](./common/img/lic-copyright.svg) |
 | [Skype](skype/README.md) | VoIP and Videoconferencing Client | [&#127968;](https://www.skype.com/) | ![](./common/img/lic-copyright.svg) |
 | [Speccy](speccy/README.md) | Display hardware computer information | [&#127968;](https://www.ccleaner.com/speccy) | ![](./common/img/lic-copyright.svg) |
 | [SSHFS-Win](sshfs-win/README.md) | Connect network drive on an SSH/SFTP server | [&#127968;](https://github.com/billziss-gh/sshfs-win) | ![](./common/img/lic-copyright.svg) |
 | [SumatraPDF](sumatrapdf/README.md) | Free and open-source document viewer (PDF, DjVu, EPUB...) | [&#127968;](https://www.sumatrapdfreader.org/free-pdf-reader) | ![](./common/img/lic-copyleft.svg) |
 | [TeamViewer](teamviewer/README.md) | Remote access and remote control | [&#127968;](https://www.teamviewer.com) | ![](./common/img/lic-copyright.svg) |
 | [Telegram Messenger](telegram/README.md) | Desktop Instant messaging application | [&#127968;](https://telegram.org/) | ![](./common/img/lic-copyright.svg) |
 | [TexMaker](texmaker/README.md) | Free cross-platform LaTeX editor | [&#127968;](https://www.xm1math.net/texmaker/) | ![](./common/img/lic-copyleft.svg) |
 | [TortoiseSVN](tortoisesvn/README.md) | Subversion Client | [&#127968;](https://tortoisesvn.net/) | ![](./common/img/lic-copyleft.svg) |
 | [Ultracopier](ultracopier/README.md) | File-copying software | [&#127968;](https://ultracopier.herman-brule.com/) | ![](./common/img/lic-copyright.svg) |
 | [VeraCrypt](veracrypt/README.md) | Crypt disk and volume (USK key) | [&#127968;](https://veracrypt.fr/) | ![](./common/img/lic-copyleft.svg) |
 | [VirtualBox6](virtualbox6/README.md) | Oracle Hypervisor for virtual machines | [&#127968;](https://www.virtualbox.org/) | ![](./common/img/lic-copyright.svg) |
 | [VirtualBox7](virtualbox/README.md) | Oracle Hypervisor for virtual machines | [&#127968;](https://www.virtualbox.org/) | ![](./common/img/lic-copyright.svg) |
 | [VisualRedist (Action)](visualredist/README.md) | Microsoft Visual C++ Redistributable Library update for all version | [&#127968;](https://learn.microsoft.com/fr-fr/cpp/windows/latest-supported-vc-redist) | ![](./common/img/lic-copyright.svg) |
 | [VLC](vlc/README.md) | VideoLAN media player Client | [&#127968;](https://www.videolan.org/) | ![](./common/img/lic-copyleft.svg) |
 | [VMware Horizon Client](vmwarehorizon/README.md) | Client for VDI VMware Horizon (virtual desktop) | [&#127968;](https://www.vmware.com/products/horizon.html) | ![](./common/img/lic-copyright.svg) |
 | [VSCode](vscode/README.md) | Microsoft Source-code editor | [&#127968;](https://code.visualstudio.com/) | ![](./common/img/lic-copyright.svg) |
 | [Webex](webex/README.md) | Cisco Web conferencing and videoconferencing Client | [&#127968;](https://www.webex.com/) | ![](./common/img/lic-copyright.svg) |
 | [WinDirStat](windirstat/README.md) | Disk usage viewer and cleanup tool | [&#127968;](https://windirstat.net/) | ![](./common/img/lic-copyleft.svg) |
 | [Windows11Update](windows11update/README.md) | Update Windows 10 or 11 to the last version of Windows 11 | [&#127968;](https://www.microsoft.com/software-download/windows11) | ![](./common/img/lic-copyright.svg) |
 | [WinMerge](winmerge/README.md) | Diff between two or three files | [&#127968;](https://winmerge.org/) | ![](./common/img/lic-copyright.svg) |
 | [WinSCP](winscp/README.md) | SCP and SFTP file transfert | [&#127968;](https://winscp.net/) | ![](./common/img/lic-copyleft.svg) |
 | [Wireshark](wireshark/README.md) | Network Packet Analyser | [&#127968;](https://wireshark.org/) | ![](./common/img/lic-copyleft.svg) |
 | [X2GoClient](x2goclient/README.md) | Client Windows for X2GO (NX) Linux remote desktop | [&#127968;](https://wiki.x2go.org/doku.php/start) | ![](./common/img/lic-copyleft.svg) |
 | [XnViewMP](xnviewmp/README.md) | Image viewer, browser and converter | [&#127968;](https://www.xnview.com) | ![](./common/img/lic-copyright.svg) |
 | [Xournal++](xournalpp/README.md) | PDF annotate and hand note-taking software | [&#127968;](https://github.com/xournalpp/xournalpp) | ![](./common/img/lic-copyleft.svg) |
 | [Zoom](zoom/README.md) | Web Conference Client | [&#127968;](https://zoom.us/) | ![](./common/img/lic-copyright.svg) |
 | [Zotero](zotero/README.md) | Manage bibliographic data | [&#127968;](https://www.zotero.org/) | ![](./common/img/lic-copyleft.svg) |
