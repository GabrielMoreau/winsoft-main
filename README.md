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
malheureusement, il y a de nombreux p

Unfortunately, many installation programs `setup.exe` have no version
number (Product Version). This is a pity, as there is sometimes some
doubt as to the actual version of a program.

Similarly, some MSI packages have the version number in the comment or
subject line, but not all. It is therefore difficult to always validate
this version number.

## List of 79 packages

 | Software | Detail | &#127968; |
 | -------- | ------ | --------- |
 | [7-Zip](7zip/README.md) | File archiver with a high compression ratio | [&#127968;](https://www.7-zip.org/)  |
 | [AcrobatReader](acrobatreader/README.md) | Adobe PDF reader | [&#127968;](https://www.adobe.com/)  |
 | [AnyConnect](anyconnect/README.md) | Cisco AnyConnect VPN | [&#127968;](https://www.cisco.com/c/en/us/security/vpn-endpoint-security-clients/)  |
 | [Arduino IDE](arduinoide/README.md) | Integrated Development Environment for Arduino | [&#127968;](https://www.arduino.cc/)  |
 | [Audacity](audacity/README.md) | Digital Audio Editor | [&#127968;](https://wiki.audacityteam.org/wiki/Audacity_Wiki_Home_Page)  |
 | [Avidemux](avidemux/README.md) | Vector graphics editor | [&#127968;](http://fixounet.free.fr/avidemux/)  |
 | [Balena Etcher](balenaetcher/README.md) | Flash OS images to SD cards & USB drives, safely and easily | [&#127968;](https://etcher.balena.io/)  |
 | [Bandicut](bandicut/README.md) | Join and cut video | [&#127968;](https://www.bandicam.com/bandicut-video-cutter/)  |
 | [Blender](blender/README.md) | 3D computer graphics software (animated films, virtual reality) | [&#127968;](https://www.blender.org/)  |
 | [BlueKenue](bluekenue/README.md) | Tool for hydraulic modellers | [&#127968;](https://nrc.canada.ca/fr/recherche-developpement/produits-services/logiciels-applications/blue-kenuetm-logiciel-modelisateurs-hydrauliques)  |
 | [CCleaner](ccleaner/README.md) | Clean computer files and register keys | [&#127968;](https://www.ccleaner.com/)  |
 | [Chrome](chrome/README.md) | Google Chrome navigator | [&#127968;](https://www.google.com/chrome/)  |
 | [CitrixWorkspace](citrixworkspace/README.md) | Citrix remote workspace client | [&#127968;](https://www.citrix.com/)  |
 | [Darktable](darktable/README.md) | Photography application and raw developer | [&#127968;](https://www.darktable.org/)  |
 | [Defraggler](defraggler/README.md) | Hard disk defragmentation utility | [&#127968;](https://www.ccleaner.com/defraggler)  |
 | [Dell Command Update](dellcmdupdate/README.md) | Update BIOS and Firmware for Dell computer | [&#127968;](https://www.dell.com/)  |
 | [Digikam](digikam/README.md) | Image organizer and tag editor  | [&#127968;](https://www.digikam.org/)  |
 | [Engauge Digitizer](engaugedigitizer/README.md) | Digitalize curve image to data point | [&#127968;](https://markummitchell.github.io/engauge-digitizer/)  |
 | [FastStone Image Viewer](fsimageviewer/README.md) | Image browser, converter and editor | [&#127968;](https://www.faststone.org/)  |
 | [FileZilla](filezilla/README.md) | Graphical two panel FTP/SFTP client | [&#127968;](https://filezilla-project.org/)  |
 | [FlashPlayer (Uninstall)](flashplayer-uninstall/README.md) | Remove all version of Adobe Flash Player | [&#127968;](https://www.adobe.com/products/flashplayer/end-of-life.html)  |
 | [FreeCAD](freecad/README.md) | Parametric 3D modeler (CAD) | [&#127968;](https://www.freecad.org/)  |
 | [Gimp](gimp/README.md) | Image graphics editor | [&#127968;](https://www.gimp.org/)  |
 | [GitForWindows](gitforwindows/README.md) | Git for the Windows OS | [&#127968;](https://gitforwindows.org/)  |
 | [Gwyddion](gwyddion/README.md) | Data visualization and analysis for SPM | [&#127968;](http://gwyddion.net/)  |
 | [HandBrake](handbrake/README.md) | Video converter | [&#127968;](https://handbrake.fr/)  |
 | [HP Image Assistant](hpimageassist/README.md) | Assistance to IT System Administrators (HPIA) for HP computer | [&#127968;](https://www.hp.com/us-en/solutions/client-management-solutions.html)  |
 | [ImageJ](imagej/README.md) | Image processing program (Fiji Distribution) | [&#127968;](https://imagej.net/)  |
 | [Inkscape](inkscape/README.md) | Vector graphics editor | [&#127968;](https://inkscape.org/)  |
 | [Kaspersky Endpoint (Uninstall)](kaspersky-uninstall/README.md) | Silent remove Kaspersky Endpoint | [&#127968;](https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb/-/tree/master/dists/uninstall-kaspersky)  |
 | [KeepassXC](keepassxc/README.md) | Free and open-source password manager. | [&#127968;](https://keepassxc.org/)  |
 | [LibreOffice](libreoffice/README.md) | Libre Office suite based on the OpenDocument standard | [&#127968;](https://www.libreoffice.org/)  |
 | [LightBulb](lightbulb/README.md) | Automatically adjusts screen gamma and color temperature during the day | [&#127968;](https://github.com/Tyrrrz/LightBulb)  |
 | [MiKTeX](miktex/README.md) | TeX and LaTeX distribution | [&#127968;](https://miktex.org/)  |
 | [Mozilla Firefox](firefox/README.md) | Web navigator | [&#127968;](https://www.mozilla.org)  |
 | [Mozilla Thunderbird](thunderbird/README.md) | Mail reader | [&#127968;](https://www.thunderbird.net/)  |
 | [MSEdge](msedge/README.md) | Microsoft Edge (Chrome) navigator | [&#127968;](https://www.microsoft.com/en-us/edge/business)  |
 | [MSTeams](teams/README.md) | Microsoft Videoconferencing and communication platform | [&#127968;](https://www.microsoft.com/fr-fr/microsoft-teams/)  |
 | [Nextcloud](nextcloud/README.md) | Cloud Suite agent | [&#127968;](https://nextcloud.com/)  |
 | [Notepad++](notepadpp/README.md) | Text editor | [&#127968;](https://notepad-plus-plus.org)  |
 | [OBS Studio](obsstudio/README.md) | Screencasting and streaming application | [&#127968;](https://obsproject.com/)  |
 | [OCSInventory-Agent](ocsinventory-agent/README.md) | Windows Agent for OCS-Inventory | [&#127968;](https://ocsinventory-ng.org)  |
 | [OpenShot](openshot/README.md) | Open-source video editor | [&#127968;](https://www.openshot.org/)  |
 | [OSBIOSUpdateNow (Action)](osbiosupdatenow/README.md) | Force Windows and DELL/HP BIOS to update now |   |
 | [ParaView](paraview/README.md) | Vector graphics editor | [&#127968;](https://www.paraview.org/)  |
 | [PDFCreator](pdfcreator/README.md) | Create PDF file | [&#127968;](https://www.pdfforge.org/)  |
 | [PDFsam Basic](pdfsam/README.md) | Split, merge, extract PDF files | [&#127968;](https://pdfsam.org/)  |
 | [PuTTY](putty/README.md) | SSH Client | [&#127968;](https://www.chiark.greenend.org.uk/~sgtatham/putty/)  |
 | [Recuva](recuva/README.md) | Recovers files on Windows computer | [&#127968;](https://www.ccleaner.com/recuva)  |
 | [RStudio](rstudio/README.md) | Integrated development environment for R (include R) | [&#127968;](https://github.com/rstudio/rstudio,)  |
 | [RTools](rtools/README.md) | Extend R language from source packages | [&#127968;](https://cran.r-project.org/bin/windows/Rtools/)  |
 | [SimpleTruss](simpletruss/README.md) | Drawing and calculating simple lattices | [&#127968;](http://www.apartmina.cz/simpletruss/)  |
 | [Skype](skype/README.md) | VoIP and Videoconferencing Client | [&#127968;](https://www.skype.com/)  |
 | [Speccy](speccy/README.md) | Display hardware computer information | [&#127968;](https://www.ccleaner.com/speccy)  |
 | [SSHFS-Win](sshfs-win/README.md) | Connect network drive on an SSH/SFTP server | [&#127968;](https://github.com/billziss-gh/sshfs-win)  |
 | [SumatraPDF](sumatrapdf/README.md) | Free and open-source document viewer (PDF, DjVu, EPUB...) | [&#127968;](https://www.sumatrapdfreader.org/free-pdf-reader)  |
 | [TeamViewer](teamviewer/README.md) | Remote access and remote control | [&#127968;](https://www.teamviewer.com)  |
 | [Telegram Messenger](telegram/README.md) | Desktop Instant messaging application | [&#127968;](https://telegram.org/)  |
 | [TexMaker](texmaker/README.md) | Free cross-platform LaTeX editor | [&#127968;](https://www.xm1math.net/texmaker/)  |
 | [TortoiseSVN](tortoisesvn/README.md) | Subversion Client | [&#127968;](https://tortoisesvn.net/)  |
 | [Ultracopier](ultracopier/README.md) | File-copying software | [&#127968;](https://ultracopier.herman-brule.com/)  |
 | [VeraCrypt](veracrypt/README.md) | Crypt disk and volume (USK key) | [&#127968;](https://veracrypt.fr/)  |
 | [VirtualBox6](virtualbox6/README.md) | Oracle Hypervisor for virtual machines | [&#127968;](https://www.virtualbox.org/)  |
 | [VirtualBox7](virtualbox/README.md) | Oracle Hypervisor for virtual machines | [&#127968;](https://www.virtualbox.org/)  |
 | [VisualRedist (Action)](visualredist/README.md) | Microsoft Visual C++ Redistributable Library update for all version | [&#127968;](https://learn.microsoft.com/fr-fr/cpp/windows/latest-supported-vc-redist)  |
 | [VLC](vlc/README.md) | VideoLAN media player Client | [&#127968;](https://www.videolan.org/)  |
 | [VMware Horizon Client](vmwarehorizon/README.md) | Client for VDI VMware Horizon (virtual desktop) | [&#127968;](https://www.vmware.com/products/horizon.html)  |
 | [VSCode](vscode/README.md) | Microsoft Source-code editor | [&#127968;](https://code.visualstudio.com/)  |
 | [Webex](webex/README.md) | Cisco Web conferencing and videoconferencing Client | [&#127968;](https://www.webex.com/)  |
 | [WinDirStat](windirstat/README.md) | Disk usage viewer and cleanup tool | [&#127968;](https://windirstat.net/)  |
 | [Windows11Update](windows11update/README.md) | Update Windows 10 or 11 to the last version of Windows 11 | [&#127968;](https://www.microsoft.com/software-download/windows11)  |
 | [WinMerge](winmerge/README.md) | Diff between two or three files | [&#127968;](https://winmerge.org/)  |
 | [WinSCP](winscp/README.md) | SCP and SFTP file transfert | [&#127968;](https://winscp.net/)  |
 | [Wireshark](wireshark/README.md) | Network Packet Analyser | [&#127968;](https://wireshark.org/)  |
 | [X2GoClient](x2goclient/README.md) | Client Windows for X2GO (NX) Linux remote desktop | [&#127968;](https://wiki.x2go.org/doku.php/start)  |
 | [XnViewMP](xnviewmp/README.md) | Image viewer, browser and converter | [&#127968;](https://www.xnview.com)  |
 | [Xournal++](xournalpp/README.md) | PDF annotate and hand note-taking software | [&#127968;](https://github.com/xournalpp/xournalpp)  |
 | [Zoom](zoom/README.md) | Web Conference Client | [&#127968;](https://zoom.us/)  |
 | [Zotero](zotero/README.md) | Manage bibliographic data | [&#127968;](https://www.zotero.org/)  |
