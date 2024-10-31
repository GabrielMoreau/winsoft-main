# RTools - Extend R language from source packages

Toolchains is a free and open-source software for building R
and R packages from source on Windows.
This package build an RTools package version compatible with the [RStudio](../rstudio) R version embeded.
So you need to build the RStudio package before.

* Website : https://cran.r-project.org/bin/windows/Rtools/

* Download : https://cran.r-project.org/bin/windows/Rtools/rtools43/rtools.html

To silent uninstall RTools (for example version 4.3)
```bat
C:\rtools43\unins000.exe /VERYSILENT /SUPPRESSMSGBOXES
```


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Rtools 4.3 (5958-5975) | The R Foundation | 4.3.5958 | `Rtools43_is1` | `"C:\rtools43\unins000.exe"` |
