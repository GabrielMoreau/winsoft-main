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
