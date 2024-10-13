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

The master Git repository in on the [GRICAD Gitlab](https://gricad-gitlab.univ-grenoble-alpes.fr/legi/soft/trokata/winsoft-main).
Other Git repository are mirror or fork.

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

## References

There are projects with a similar objective.
This allows you to find installation parameters
so that the installation is silent, for example.

Here are just a few of these projects or websites with information
that is often relevant:

* [Chocolatey](https://chocolatey.org/) - [wikipedia](https://en.wikipedia.org/wiki/Chocolatey), [github](https://github.com/chocolatey/choco)
* [WAPT](https://www.tranquil.it/) - [wikipedia](https://fr.wikipedia.org/wiki/Wapt_(logiciel))
* [SilentInstallHQ](https://silentinstallhq.com) - [knowledge-base](https://silentinstallhq.com/silent-install-knowledge-base/)
* [Silent-Install.net](https://silent-install.net/)
* [Scoop](https://github.com/ScoopInstaller/Scoop) - [wikipedia](https://en.wikipedia.org/wiki/Scoop_Package_Manager), [non-portable](https://github.com/ScoopInstaller/Nonportable)
* [WPKG](https://wpkg.org/)

There's an up-to-date list of [package managers](https://en.wikipedia.org/wiki/List_of_software_package_management_systems)
on [Wikipedia](https://en.wikipedia.org).

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

To find out which parameters you can adapt to your site, the `_common`
folder, whose main file is `conf.mk`, lists these parameters with
default values (which don't always work).

## How it works

Most of the downloads use the `curl` tool and not `wget`,
this allows to have the scripts running under GNU/Linux and MacOSX environments.
Indeed, the packages are currently all built under these environments
to facilitate automation.

* Note the optional use of the `peres` tool (Debian `pev` package)
which allows to retrieve the version number in a `setup.exe` installation file.
If this tool is available, a version number check is performed.

* You can use `7z` (Debian `p7zip-full` package)
or `exiftool` (Debian `libimage-exiftool-perl` package)
to retrieve the product version number.

Example (same result with the three command)
```bash
7z l tmp/Windows11InstallationAssistant.exe | grep '^ProductVersion:' | cut -f 2 -d ' '
peres -v tmp/Windows11InstallationAssistant.exe | grep '^Product Version:' | awk '{print $3}'
exiftool -ProductVersion tmp/Windows11InstallationAssistant.exe | awk '{print $4}'
```

Unfortunately, many installation programs `setup.exe` have no version
number (Product Version). This is a pity, as there is sometimes some
doubt as to the actual version of a program.

Similarly, some MSI packages have the version number in the comment or
subject line, but not all. It is therefore difficult to always validate
this version number. We can sometime use `msiextract` (or `7z`) to
extract an `.exe` file and then use `peres` on it!
Please devops, put always the version number clearly in the comment...

```bash
apt install make curl wget pev msitools p7zip-full libimage-exiftool-perl
```

## List of 120 packages

 |   | Software | Detail | &#127968; |   |
 | - | -------- | ------ | --------- | - |
 | 001 | [3D Slicer](3dslicer/README.md) | Visualization and analysis of medical image computing data sets | [&#127968;](https://www.slicer.org/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 002 | [7-Zip](7zip/README.md) | File archiver with a high compression ratio | [&#127968;](https://www.7-zip.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 003 | [AcrobatReader](acrobatreader/README.md) | Adobe PDF reader | [&#127968;](https://www.adobe.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 004 | [Advanced Renamer](advancedrenamer/README.md) | Rename multiple files and folders at once | [&#127968;](https://www.advancedrenamer.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 005 | [AnyDesk](anydesk/README.md) | Remote desktop application | [&#127968;](https://anydesk.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 006 | [Arduino IDE](arduinoide/README.md) | Integrated Development Environment for Arduino | [&#127968;](https://www.arduino.cc/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 007 | [Audacity](audacity/README.md) | Digital Audio Editor | [&#127968;](https://wiki.audacityteam.org/wiki/Audacity_Wiki_Home_Page) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 008 | [Autopsy](autopsy/README.md) | Digital forensics and recover platform | [&#127968;](https://www.autopsy.com/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 009 | [Avidemux](avidemux/README.md) | Video editor designed for simple cutting, filtering and encoding tasks | [&#127968;](http://fixounet.free.fr/avidemux/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 010 | [Balena Etcher](balenaetcher/README.md) | Flash OS images to SD cards & USB drives, safely and easily | [&#127968;](https://etcher.balena.io/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 011 | [Bandicut](bandicut/README.md) | Join and cut video | [&#127968;](https://www.bandicam.com/bandicut-video-cutter/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 012 | [Bitvise SSH Client](bvsshclient/README.md) | Graphical SSH client | [&#127968;](https://www.bitvise.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 013 | [BleachBit](bleachbit/README.md) | Clean computer files and privacy manager | [&#127968;](https://www.bleachbit.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 014 | [Blender](blender/README.md) | 3D computer graphics software (animated films, virtual reality) | [&#127968;](https://www.blender.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 015 | [BlueKenue](bluekenue/README.md) | Tool for hydraulic modellers | [&#127968;](https://nrc.canada.ca/fr/recherche-developpement/produits-services/logiciels-applications/blue-kenuetm-logiciel-modelisateurs-hydrauliques) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 016 | [CCleaner](ccleaner/README.md) | Clean computer files and register keys | [&#127968;](https://www.ccleaner.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 018 | [Chrome](chrome/README.md) | Google Chrome navigator | [&#127968;](https://www.google.com/chrome/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 019 | [Cisco AnyConnect](anyconnect/README.md) | Secure Client AnyConnect VPN suite | [&#127968;](https://www.cisco.com/c/en/us/security/vpn-endpoint-security-clients/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 020 | [CitrixWorkspace](citrixworkspace/README.md) | Citrix remote workspace client | [&#127968;](https://www.citrix.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 021 | [Darktable](darktable/README.md) | Photography application and raw developer | [&#127968;](https://www.darktable.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 022 | [Defraggler](defraggler/README.md) | Hard disk defragmentation utility | [&#127968;](https://www.ccleaner.com/defraggler) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 023 | [Dell Command Update](dellcmdupdate/README.md) | Update BIOS and Firmware for Dell computer | [&#127968;](https://www.dell.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 024 | [Digikam](digikam/README.md) | Image organizer and tag editor  | [&#127968;](https://www.digikam.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 025 | [Engauge Digitizer](engaugedigitizer/README.md) | Digitalize curve image to data point | [&#127968;](https://markummitchell.github.io/engauge-digitizer/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 026 | [FastStone Image Viewer](fsimageviewer/README.md) | Image browser, converter and editor | [&#127968;](https://www.faststone.org/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 027 | [FileZilla](filezilla/README.md) | Graphical two panel FTP/SFTP client | [&#127968;](https://filezilla-project.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 029 | [FreeCAD](freecad/README.md) | Parametric 3D modeler (CAD) | [&#127968;](https://www.freecad.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 030 | [Freeplane](freeplane/README.md) | Tools for mind mapping | [&#127968;](https://www.freeplane.org/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 031 | [Gimp](gimp/README.md) | Image graphics editor | [&#127968;](https://www.gimp.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 032 | [GitForWindows](gitforwindows/README.md) | Git for the Windows OS | [&#127968;](https://gitforwindows.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 033 | [Gwyddion](gwyddion/README.md) | Data visualization and analysis for SPM | [&#127968;](http://gwyddion.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 034 | [HandBrake](handbrake/README.md) | Video converter | [&#127968;](https://handbrake.fr/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 035 | [HP Image Assistant](hpimageassist/README.md) | Assistance to IT System Administrators (HPIA) for HP computer | [&#127968;](https://www.hp.com/us-en/solutions/client-management-solutions.html) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 036 | [HP Support Assistant](hpsupportassist/README.md) | Assist for computer maintenance, software upgrades, troubleshooting problems | [&#127968;](https://support.hp.com/us-en/help/hp-support-assistant) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 037 | [Hurukai-Agent](hurukai/README.md) | HarfangLab EDR agent | [&#127968;](https://harfanglab.io/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 038 | [ImageJ](imagej/README.md) | Image processing program (Fiji Distribution) | [&#127968;](https://imagej.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 039 | [Inkscape](inkscape/README.md) | Vector graphics editor | [&#127968;](https://inkscape.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 042 | [KeepassXC](keepassxc/README.md) | Free and open-source password manager. | [&#127968;](https://keepassxc.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 043 | [KiCad](kicad/README.md) | Electronic design automation | [&#127968;](https://www.kicad.org) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 044 | [K-Lite Codec Pack](klitecodec/README.md) | Vector graphics editor | [&#127968;](https://codecguide.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 045 | [LibreOffice](libreoffice/README.md) | Libre Office suite based on the OpenDocument standard | [&#127968;](https://www.libreoffice.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 046 | [LightBulb](lightbulb/README.md) | Automatically adjusts screen gamma and color temperature during the day | [&#127968;](https://github.com/Tyrrrz/LightBulb) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 047 | [Lychee SLicer](lycheeslicer/README.md) | Slicer for Resin and Filament 3D Printers | [&#127968;](https://mango3d.io/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 048 | [MiKTeX](miktex/README.md) | TeX and LaTeX distribution | [&#127968;](https://miktex.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 049 | [Mozilla Firefox](firefox/README.md) | Web navigator | [&#127968;](https://www.mozilla.org) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 050 | [Mozilla Thunderbird](thunderbird/README.md) | Mail reader | [&#127968;](https://www.thunderbird.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 051 | [MS Edge](msedge/README.md) | Microsoft Edge (Chrome) navigator | [&#127968;](https://www.microsoft.com/en-us/edge/business) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 052 | [MS Teams](teams/README.md) | Microsoft Videoconferencing and communication platform | [&#127968;](https://www.microsoft.com/fr-fr/microsoft-teams/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 053 | [MS VSCode](vscode/README.md) | Microsoft Source-code editor | [&#127968;](https://code.visualstudio.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 054 | [Nextcloud](nextcloud/README.md) | Cloud Suite agent | [&#127968;](https://nextcloud.com/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 055 | [Notepad++](notepadpp/README.md) | Text editor | [&#127968;](https://notepad-plus-plus.org) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 056 | [OBS Studio](obsstudio/README.md) | Screencasting and streaming application | [&#127968;](https://obsproject.com/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 057 | [OCSInventory-Agent](ocsinventory-agent/README.md) | Windows Agent for OCS-Inventory | [&#127968;](https://ocsinventory-ng.org) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 058 | [Octave](octave/README.md) | Scientific computing and numerical computation | [&#127968;](https://octave.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 059 | [OpenShot](openshot/README.md) | Open-source video editor | [&#127968;](https://www.openshot.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 060 | [OpenVPN Connect](openvpn/README.md) | Virtual Private Network (VPN) SSL Client | [&#127968;](https://openvpn.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 061 | [ParaView](paraview/README.md) | Vector graphics editor | [&#127968;](https://www.paraview.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 062 | [PDFCreator](pdfcreator/README.md) | Create PDF file | [&#127968;](https://www.pdfforge.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 063 | [PDFsam Basic](pdfsam/README.md) | Split, merge, extract PDF files | [&#127968;](https://pdfsam.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 064 | [Picocrypt](picocrypt/README.md) | Secure encryption tool (Crypt files) | [&#127968;](https://github.com/HACKERALERT/Picocrypt) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 065 | [Proton Mail Bridge](protonmailbridge/README.md) | Secure messaging client | [&#127968;](https://proton.me/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 066 | [Prusa Slicer](prusaslicer/README.md) | Slicer and converts 3D models (STL, OBJ, AMF) into G-code instructions for FFF printers | [&#127968;](https://www.prusa3d.com) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 067 | [PuTTY](putty/README.md) | SSH Client | [&#127968;](https://www.chiark.greenend.org.uk/~sgtatham/putty/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 068 | [Raise3D ideaMaker](ideamaker/README.md) | Slicer Software (3D printing) | [&#127968;](https://www.raise3d.eu/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 069 | [Recuva](recuva/README.md) | Recovers files on Windows computer | [&#127968;](https://www.ccleaner.com/recuva) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 070 | [RocketChat](rocketchat/README.md) | Chat desktop client for RocketChat servers | [&#127968;](https://www.rocket.chat/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 071 | [RStudio](rstudio/README.md) | Integrated development environment for R (include R) | [&#127968;](https://github.com/rstudio/rstudio,) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 072 | [RTools](rtools/README.md) | Extend R language from source packages | [&#127968;](https://cran.r-project.org/bin/windows/Rtools/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 076 | [Signal-Desktop](signal-desktop/README.md) | Encrypted instant messaging, voice, and video calls | [&#127968;](https://signal-desktop.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 077 | [SimpleTruss](simpletruss/README.md) | Drawing and calculating simple lattices | [&#127968;](http://www.apartmina.cz/simpletruss/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 078 | [Skype](skype/README.md) | VoIP and Videoconferencing Client | [&#127968;](https://www.skype.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 079 | [Speccy](speccy/README.md) | Display hardware computer information | [&#127968;](https://www.ccleaner.com/speccy) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 080 | [SSHFS-Win](sshfs-win/README.md) | Connect network drive on an SSH/SFTP server | [&#127968;](https://github.com/billziss-gh/sshfs-win) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 081 | [SumatraPDF](sumatrapdf/README.md) | Free and open-source document viewer (PDF, DjVu, EPUB...) | [&#127968;](https://www.sumatrapdfreader.org/free-pdf-reader) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 082 | [Sysinternals Suite](sysinternals/README.md) | Technical resources and utilities to manage, diagnose and monitor a Windows environment | [&#127968;](http://technet.microsoft.com/sysinternals) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 083 | [Tabby](tabby/README.md) | Modern terminal for local shells, SSH, etc | [&#127968;](https://tabby.sh/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 084 | [TeamViewer](teamviewer/README.md) | Remote access and remote control | [&#127968;](https://www.teamviewer.com) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 085 | [Telegram Messenger](telegram/README.md) | Desktop Instant messaging application | [&#127968;](https://telegram.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 086 | [TexMaker](texmaker/README.md) | Free cross-platform LaTeX editor | [&#127968;](https://www.xm1math.net/texmaker/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 087 | [TortoiseSVN](tortoisesvn/README.md) | Subversion Client | [&#127968;](https://tortoisesvn.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 088 | [UltiMaker Cura](ultimakercura/README.md) | 3D printing software | [&#127968;](https://ultimaker.com) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 089 | [Ultracopier](ultracopier/README.md) | File-copying software | [&#127968;](https://ultracopier.herman-brule.com/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 093 | [VeraCrypt](veracrypt/README.md) | Crypt disk and volume (USK key) | [&#127968;](https://veracrypt.fr/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 094 | [VirtualBox6](virtualbox6/README.md) | Oracle Hypervisor for virtual machines | [&#127968;](https://www.virtualbox.org/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 095 | [VirtualBox7](virtualbox/README.md) | Oracle Hypervisor for virtual machines | [&#127968;](https://www.virtualbox.org/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 096 | [VisIt](visit/README.md) | Interactive, scalable, visualization, animation and analysis tool | [&#127968;](https://visit-dav.github.io/visit-website/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 097 | [VLC](vlc/README.md) | VideoLAN media player Client | [&#127968;](https://www.videolan.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 098 | [VMware Horizon Client](vmwarehorizon/README.md) | Client for VDI VMware Horizon (virtual desktop) | [&#127968;](https://customerconnect.omnissa.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 099 | [VMware Workstation Player](vmwareplayer/README.md) | Virtualization software for computers | [&#127968;](https://www.vmware.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 100 | [Webex](webex/README.md) | Cisco Web conferencing and videoconferencing Client | [&#127968;](https://www.webex.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 101 | [WinDirStat](windirstat/README.md) | Disk usage viewer and cleanup tool | [&#127968;](https://windirstat.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 102 | [Windows11Update](windows11update/README.md) | Update Windows 10 or 11 to the last version of Windows 11 | [&#127968;](https://www.microsoft.com/software-download/windows11) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 103 | [WinMerge](winmerge/README.md) | Diff between two or three files | [&#127968;](https://winmerge.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 104 | [WinSCP](winscp/README.md) | SCP and SFTP file transfert | [&#127968;](https://winscp.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 105 | [Wireshark](wireshark/README.md) | Network Packet Analyser | [&#127968;](https://wireshark.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 106 | [X2GoClient](x2goclient/README.md) | Client Windows for X2GO (NX) Linux remote desktop | [&#127968;](https://wiki.x2go.org/doku.php/start) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 107 | [XnViewMP](xnviewmp/README.md) | Image viewer, browser and converter | [&#127968;](https://www.xnview.com) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 108 | [Xournal++](xournalpp/README.md) | PDF annotate and hand note-taking software | [&#127968;](https://github.com/xournalpp/xournalpp) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | 109 | [Zoom](zoom/README.md) | Web Conference Client | [&#127968;](https://zoom.us/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | 110 | [Zotero](zotero/README.md) | Manage bibliographic data | [&#127968;](https://www.zotero.org/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |

 | Uninstall | Detail | &#127968; |   |
 | -------- | ------ | --------- | - |
 | [AcrobatReader (Uninstall)](acrobatreader/README.md) | Adobe PDF reader | [&#127968;](https://www.adobe.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [AnyDesk (Uninstall)](anydesk/README.md) | Remote desktop application | [&#127968;](https://anydesk.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [CCleaner (Uninstall)](ccleaner/README.md) | Clean computer files and register keys | [&#127968;](https://www.ccleaner.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Chrome (Uninstall)](chrome/README.md) | Google Chrome navigator | [&#127968;](https://www.google.com/chrome/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [FlashPlayer (Uninstall)](flashplayer-uninstall/README.md) | Remove all version of Adobe Flash Player | [&#127968;](https://www.adobe.com/products/flashplayer/end-of-life.html) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Gwyddion (Uninstall)](gwyddion/README.md) | Data visualization and analysis for SPM | [&#127968;](http://gwyddion.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Java JRE (Uninstall)](javajre8-uninstall/README.md) | Remove version 7 and 8 of Java Runtime Environment | [&#127968;](https://www.oracle.com/java/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Kaspersky Endpoint (Uninstall)](kaspersky-uninstall/README.md) | Silent remove Kaspersky Endpoint | [&#127968;](https://gitlab.in2p3.fr/resinfo-gt/swmb/resinfo-swmb/-/tree/master/dists/uninstall-kaspersky) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Mozilla Thunderbird (Uninstall)](thunderbird/README.md) | Mail reader | [&#127968;](https://www.thunderbird.net/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [MS VSCode (Uninstall)](vscode/README.md) | Microsoft Source-code editor | [&#127968;](https://code.visualstudio.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Skype (Uninstall)](skype/README.md) | VoIP and Videoconferencing Client | [&#127968;](https://www.skype.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [TeamViewer (Uninstall)](teamviewer/README.md) | Remote access and remote control | [&#127968;](https://www.teamviewer.com) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Zoom (Uninstall)](zoom/README.md) | Web Conference Client | [&#127968;](https://zoom.us/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |

 | Action | Detail | &#127968; |   |
 | -------- | ------ | --------- | - |
 | [Check WithSecure Hotfixes (Action)](check-withsecurehotfixes/README.md) | Test the deployment of updates | [&#127968;](https://www.withsecure.com/) | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Run Reboot (Action)](action-reboot/README.md) | Restart the computer |  | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Run Reboot if pending (Action)](action-rebootifpending/README.md) | Restart computer if actions in progress remain pending |  | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Run Shutdown (Action)](action-shutdown/README.md) | Poweroff the computer |  | [🄯](https://en.wikipedia.org/wiki/Free_license "Free/Libre Software") |
 | [Update MS Visual Redistributable (Action)](update-visualredist/README.md) | Microsoft Visual C++ Redistributable Library update for all version | [&#127968;](https://learn.microsoft.com/fr-fr/cpp/windows/latest-supported-vc-redist) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Update MS Windows Desktop Runtime (Action)](update-windeskruntime/README.md) | Runtime engine for Microsoft .NET desktop applications update for all 64 bits version | [&#127968;](https://dotnet.microsoft.com/) | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
 | [Update OS and BIOS (Action)](update-osbios/README.md) | Force Windows and DELL/HP BIOS to update now |  | [©](https://en.wikipedia.org/wiki/Proprietary_software "Proprietary/Close Software") |
