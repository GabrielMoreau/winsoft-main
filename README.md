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

## List of 86 packages

 | Software | Detail | &#127968; |   |
 | -------- | ------ | --------- | - |
 | [7-Zip](7zip/README.md) | File archiver with a high compression ratio | [&#127968;](https://www.7-zip.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [AcrobatReader](acrobatreader/README.md) | Adobe PDF reader | [&#127968;](https://www.adobe.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [AnyConnect](anyconnect/README.md) | Cisco AnyConnect VPN | [&#127968;](https://www.cisco.com/c/en/us/security/vpn-endpoint-security-clients/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Arduino IDE](arduinoide/README.md) | Integrated Development Environment for Arduino | [&#127968;](https://www.arduino.cc/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Audacity](audacity/README.md) | Digital Audio Editor | [&#127968;](https://wiki.audacityteam.org/wiki/Audacity_Wiki_Home_Page) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Avidemux](avidemux/README.md) | Vector graphics editor | [&#127968;](http://fixounet.free.fr/avidemux/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Balena Etcher](balenaetcher/README.md) | Flash OS images to SD cards & USB drives, safely and easily | [&#127968;](https://etcher.balena.io/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Bandicut](bandicut/README.md) | Join and cut video | [&#127968;](https://www.bandicam.com/bandicut-video-cutter/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Bitvise SSH Client](bvsshclient/README.md) | Graphical SSH client | [&#127968;](https://www.bitvise.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [BleachBit](bleachbit/README.md) | Clean computer files and privacy manager | [&#127968;](https://www.bleachbit.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Blender](blender/README.md) | 3D computer graphics software (animated films, virtual reality) | [&#127968;](https://www.blender.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [BlueKenue](bluekenue/README.md) | Tool for hydraulic modellers | [&#127968;](https://nrc.canada.ca/fr/recherche-developpement/produits-services/logiciels-applications/blue-kenuetm-logiciel-modelisateurs-hydrauliques) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [CCleaner](ccleaner/README.md) | Clean computer files and register keys | [&#127968;](https://www.ccleaner.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Chrome](chrome/README.md) | Google Chrome navigator | [&#127968;](https://www.google.com/chrome/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [CitrixWorkspace](citrixworkspace/README.md) | Citrix remote workspace client | [&#127968;](https://www.citrix.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Darktable](darktable/README.md) | Photography application and raw developer | [&#127968;](https://www.darktable.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Defraggler](defraggler/README.md) | Hard disk defragmentation utility | [&#127968;](https://www.ccleaner.com/defraggler) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Dell Command Update](dellcmdupdate/README.md) | Update BIOS and Firmware for Dell computer | [&#127968;](https://www.dell.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Digikam](digikam/README.md) | Image organizer and tag editor  | [&#127968;](https://www.digikam.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Engauge Digitizer](engaugedigitizer/README.md) | Digitalize curve image to data point | [&#127968;](https://markummitchell.github.io/engauge-digitizer/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [FastStone Image Viewer](fsimageviewer/README.md) | Image browser, converter and editor | [&#127968;](https://www.faststone.org/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [FileZilla](filezilla/README.md) | Graphical two panel FTP/SFTP client | [&#127968;](https://filezilla-project.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [FlashPlayer (Uninstall)](flashplayer-uninstall/README.md) | Remove all version of Adobe Flash Player | [&#127968;](https://www.adobe.com/products/flashplayer/end-of-life.html) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [FreeCAD](freecad/README.md) | Parametric 3D modeler (CAD) | [&#127968;](https://www.freecad.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Gimp](gimp/README.md) | Image graphics editor | [&#127968;](https://www.gimp.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [GitForWindows](gitforwindows/README.md) | Git for the Windows OS | [&#127968;](https://gitforwindows.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Gwyddion](gwyddion/README.md) | Data visualization and analysis for SPM | [&#127968;](http://gwyddion.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [HandBrake](handbrake/README.md) | Video converter | [&#127968;](https://handbrake.fr/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [HP Image Assistant](hpimageassist/README.md) | Assistance to IT System Administrators (HPIA) for HP computer | [&#127968;](https://www.hp.com/us-en/solutions/client-management-solutions.html) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [HP Support Assistant](hpsupportassist/README.md) | Assist for computer maintenance, software upgrades, troubleshooting problems | [&#127968;](https://support.hp.com/us-en/help/hp-support-assistant) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [ImageJ](imagej/README.md) | Image processing program (Fiji Distribution) | [&#127968;](https://imagej.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Inkscape](inkscape/README.md) | Vector graphics editor | [&#127968;](https://inkscape.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Kaspersky Endpoint (Uninstall)](kaspersky-uninstall/README.md) | Silent remove Kaspersky Endpoint | [&#127968;](https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb/-/tree/master/dists/uninstall-kaspersky) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [KeepassXC](keepassxc/README.md) | Free and open-source password manager. | [&#127968;](https://keepassxc.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [LibreOffice](libreoffice/README.md) | Libre Office suite based on the OpenDocument standard | [&#127968;](https://www.libreoffice.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [LightBulb](lightbulb/README.md) | Automatically adjusts screen gamma and color temperature during the day | [&#127968;](https://github.com/Tyrrrz/LightBulb) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [MiKTeX](miktex/README.md) | TeX and LaTeX distribution | [&#127968;](https://miktex.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Mozilla Firefox](firefox/README.md) | Web navigator | [&#127968;](https://www.mozilla.org) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Mozilla Thunderbird](thunderbird/README.md) | Mail reader | [&#127968;](https://www.thunderbird.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [MSEdge](msedge/README.md) | Microsoft Edge (Chrome) navigator | [&#127968;](https://www.microsoft.com/en-us/edge/business) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [MSTeams](teams/README.md) | Microsoft Videoconferencing and communication platform | [&#127968;](https://www.microsoft.com/fr-fr/microsoft-teams/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Nextcloud](nextcloud/README.md) | Cloud Suite agent | [&#127968;](https://nextcloud.com/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Notepad++](notepadpp/README.md) | Text editor | [&#127968;](https://notepad-plus-plus.org) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [OBS Studio](obsstudio/README.md) | Screencasting and streaming application | [&#127968;](https://obsproject.com/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [OCSInventory-Agent](ocsinventory-agent/README.md) | Windows Agent for OCS-Inventory | [&#127968;](https://ocsinventory-ng.org) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [OpenShot](openshot/README.md) | Open-source video editor | [&#127968;](https://www.openshot.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [OSBIOSUpdateNow (Action)](osbiosupdatenow/README.md) | Force Windows and DELL/HP BIOS to update now |  | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [ParaView](paraview/README.md) | Vector graphics editor | [&#127968;](https://www.paraview.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [PDFCreator](pdfcreator/README.md) | Create PDF file | [&#127968;](https://www.pdfforge.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [PDFsam Basic](pdfsam/README.md) | Split, merge, extract PDF files | [&#127968;](https://pdfsam.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Proton Mail Bridge](protonmailbridge/README.md) | Secure messaging client | [&#127968;](https://proton.me/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [PuTTY](putty/README.md) | SSH Client | [&#127968;](https://www.chiark.greenend.org.uk/~sgtatham/putty/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Raise3D ideaMaker](ideamaker/README.md) | Slicer Software (3D printing) | [&#127968;](https://www.raise3d.eu/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Recuva](recuva/README.md) | Recovers files on Windows computer | [&#127968;](https://www.ccleaner.com/recuva) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [RocketChat](rocketchat/README.md) | Chat desktop client for RocketChat servers | [&#127968;](https://www.rocket.chat/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [RStudio](rstudio/README.md) | Integrated development environment for R (include R) | [&#127968;](https://github.com/rstudio/rstudio,) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [RTools](rtools/README.md) | Extend R language from source packages | [&#127968;](https://cran.r-project.org/bin/windows/Rtools/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [SimpleTruss](simpletruss/README.md) | Drawing and calculating simple lattices | [&#127968;](http://www.apartmina.cz/simpletruss/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Skype](skype/README.md) | VoIP and Videoconferencing Client | [&#127968;](https://www.skype.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Speccy](speccy/README.md) | Display hardware computer information | [&#127968;](https://www.ccleaner.com/speccy) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [SSHFS-Win](sshfs-win/README.md) | Connect network drive on an SSH/SFTP server | [&#127968;](https://github.com/billziss-gh/sshfs-win) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [SumatraPDF](sumatrapdf/README.md) | Free and open-source document viewer (PDF, DjVu, EPUB...) | [&#127968;](https://www.sumatrapdfreader.org/free-pdf-reader) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [TeamViewer](teamviewer/README.md) | Remote access and remote control | [&#127968;](https://www.teamviewer.com) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Telegram Messenger](telegram/README.md) | Desktop Instant messaging application | [&#127968;](https://telegram.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [TexMaker](texmaker/README.md) | Free cross-platform LaTeX editor | [&#127968;](https://www.xm1math.net/texmaker/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [TortoiseSVN](tortoisesvn/README.md) | Subversion Client | [&#127968;](https://tortoisesvn.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [UltiMaker Cura](ultimakercura/README.md) | 3D printing software | [&#127968;](https://ultimaker.com) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Ultracopier](ultracopier/README.md) | File-copying software | [&#127968;](https://ultracopier.herman-brule.com/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [VeraCrypt](veracrypt/README.md) | Crypt disk and volume (USK key) | [&#127968;](https://veracrypt.fr/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [VirtualBox6](virtualbox6/README.md) | Oracle Hypervisor for virtual machines | [&#127968;](https://www.virtualbox.org/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [VirtualBox7](virtualbox/README.md) | Oracle Hypervisor for virtual machines | [&#127968;](https://www.virtualbox.org/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [VisualRedist (Action)](visualredist/README.md) | Microsoft Visual C++ Redistributable Library update for all version | [&#127968;](https://learn.microsoft.com/fr-fr/cpp/windows/latest-supported-vc-redist) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [VLC](vlc/README.md) | VideoLAN media player Client | [&#127968;](https://www.videolan.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [VMware Horizon Client](vmwarehorizon/README.md) | Client for VDI VMware Horizon (virtual desktop) | [&#127968;](https://www.vmware.com/products/horizon.html) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [VSCode](vscode/README.md) | Microsoft Source-code editor | [&#127968;](https://code.visualstudio.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Webex](webex/README.md) | Cisco Web conferencing and videoconferencing Client | [&#127968;](https://www.webex.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [WinDirStat](windirstat/README.md) | Disk usage viewer and cleanup tool | [&#127968;](https://windirstat.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Windows11Update](windows11update/README.md) | Update Windows 10 or 11 to the last version of Windows 11 | [&#127968;](https://www.microsoft.com/software-download/windows11) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [WinMerge](winmerge/README.md) | Diff between two or three files | [&#127968;](https://winmerge.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [WinSCP](winscp/README.md) | SCP and SFTP file transfert | [&#127968;](https://winscp.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Wireshark](wireshark/README.md) | Network Packet Analyser | [&#127968;](https://wireshark.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [X2GoClient](x2goclient/README.md) | Client Windows for X2GO (NX) Linux remote desktop | [&#127968;](https://wiki.x2go.org/doku.php/start) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [XnViewMP](xnviewmp/README.md) | Image viewer, browser and converter | [&#127968;](https://www.xnview.com) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Xournal++](xournalpp/README.md) | PDF annotate and hand note-taking software | [&#127968;](https://github.com/xournalpp/xournalpp) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Zoom](zoom/README.md) | Web Conference Client | [&#127968;](https://zoom.us/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Zotero](zotero/README.md) | Manage bibliographic data | [&#127968;](https://www.zotero.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
