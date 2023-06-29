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

## List of package

 | Software | Detail |
 | -------- | ------ |
 | 7-Zip | File archiver with a high compression ratio |
 | AcrobatReader | Adobe PDF reader |
 | AnyConnect | Cisco AnyConnect VPN |
 | Arduino IDE | Vector graphics editor |
 | Audacity | Digital Audio Editor |
 | Avidemux | Vector graphics editor |
 | Balena Etcher | Flash OS images to SD cards & USB drives, safely and easily |
 | Bandicut | Join and cut video |
 | Blender | 3D computer graphics software (animated films, virtual reality) |
 | BlueKenue | Tool for hydraulic modellers |
 | Chrome | Google Chrome navigator |
 | CitrixWorkspace | Citrix remote workspace client |
 | Darktable | Photography application and raw developer |
 | Dell Command Update | Update BIOS and Firmware |
 | Digikam | Image organizer and tag editor  |
 | Engauge Digitizer | Digitalize curve image to data point |
 | FastStone Image Viewer | Image browser, converter and editor |
 | FileZilla | FTP/SFTP client |
 | FlashPlayer-Uninstall | Remove all version of Adobe Flash Player |
 | FreeCAD | Parametric 3D modeler (CAD) |
 | Gimp | Image graphics editor |
 | GitForWindows | Git for the Windows OS |
 | Gwyddion | Data visualization and analysis for SPM |
 | HandBrake | Video converter |
 | HP Image Assistant | HPIA |
 | ImageJ | Image processing program (Fiji Distribution) |
 | Inkscape | Vector graphics editor |
 | Kaspersky Endpoint | Uninstall script |
 | KeepassXC | Free and open-source password manager. |
 | LibreOffice | Libre Office suite based on the OpenDocument standard |
 | LightBulb | Automatically adjusts screen gamma and color temperature |
 | MiKTeX | TeX and LaTeX distribution |
 | Mozilla Firefox | Web navigator |
 | Mozilla Thunderbird | Mail reader |
 | MSEdge | Microsoft Edge (Chrome) navigator |
 | MSTeams | Microsoft Videoconferencing and communication platform |
 | Nextcloud | Cloud Suite |
 | Notepad++ | Text editor |
 | OBS Studio | Screencasting and streaming application |
 | OCSInventory-Agent | Windows Agent for OCS-Inventory |
 | OpenShot | Open-source video editor |
 | OSBIOSUpdateNow | Force Windows and DELL/HP BIOS to update now |
 | ParaView | Vector graphics editor |
 | PDFCreator | Create PDF file |
 | PDFsam Basic | Split, merge, extract PDF files |
 | PuTTY | SSH Client |
 | RStudio | Integrated development environment for R |
 | SimpleTruss | Drawing and calculating simple lattices |
 | Skype | VoIP and Videoconferencing Client |
 | SSHFS-Win | Connect network drive on an SSH/SFTP server |
 | SumatraPDF | Free and open-source document viewer (PDF, DjVu, EPUB...) |
 | TeamViewer | Remote access and remote control |
 | TexMaker | Free cross-platform LaTeX editor |
 | TortoiseSVN | Subversion Client |
 | Ultracopier | File-copying software |
 | VeraCrypt | Crypt disk and volume (USK key) |
 | VirtualBox6 | Oracle Hypervisor for virtual machines |
 | VirtualBox7 | Oracle Hypervisor for virtual machines |
 | VisualRedist | Visual C++ Redistributable Library |
 | VLC | VLC media player |
 | VMware Horizon Client | Client for VDI VMware Horizon (virtual desktop) |
 | VSCode | Source-code editor |
 | Webex | Web conferencing, videoconferencing  |
 | WinDirStat | Disk usage viewer and cleanup tool |
 | WinMerge | Diff between two or three files |
 | WinSCP | SCP and SFTP file transfert |
 | Wireshark | Network Packet Analyser |
 | X2GoClient | Client Windows for NX Linux remote desktop |
 | XnViewMP | Image viewer, browser and converter |
 | Xournal++ | PDF annotate and hand note-taking software |
 | Zoom | Web Conference Client |
 | Zotero | Manage bibliographic data |
