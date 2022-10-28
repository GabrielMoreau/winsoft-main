# WinSoft-Main - Main files for package build

Each folder (except common) contains a software (or a coherent set of software) useful for users.
In each folder, there is a `Makefile` that will allow to build the OCS Inventory package.

```bash
make
make ocs
```

You just have to put this Zip package on your server.
The command to run for the installation is always `install.bat`.

However, some packages need some parameters.
These parameters depend on your site.
So, in addition to the `winsoft-main` folder, you must have a `winsoft-conf` folder.
The `Makefile` will fetch the settings from a file in this folder.
There is an example file in the package in which a setting is needed.

Most of the downloads use the `curl` tool and not `wget`,
this allows to have the scripts running under GNU/Linux and MacOSX environments.
Indeed, the packages are currently all built under these environments
to facilitate automation.

Note the optional use of the `perez` tool (Debian `pev` package)
which allows to retrieve the version number in a `setup.exe` installation file.
If this tool is available, a version number check is performed.
