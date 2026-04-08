# MSVC Build Tools - Microsoft Visual Studio Build Tools

The Visual Studio Build Tools allows you to build native and managed MSBuild-based applications without requiring the Visual Studio IDE.
There are options to install the Visual C++ compilers and libraries, MFC, ATL, and C++/CLI support.

* Website : https://visualstudio.microsoft.com/
* Wikipedia : https://en.wikipedia.org/wiki/Visual_Studio

* Download : https://visualstudio.microsoft.com/downloads/, https://aka.ms/vs/stable/vs_BuildTools.exe
* Silent install : https://silentinstallhq.com/visual-studio-build-tools-2022-silent-install-how-to-guide/
* Parameters : https://learn.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=visualstudio&viewFallbackFrom=vs-2026


## Usage

DOS Terminal

```bat
"C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64
cmake --version
cl.exe
```

PowerShell Terminal (replace version with the good one)

```ps1
$Env:PATH = "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Tools\MSVC\<version>\bin\Hostx64\x64;$Env:PATH"
$Env:PATH = "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin;$Env:PATH"

cmake --version
cl.exe
```

* `cmake` -> `C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe`


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Visual Studio Build Tools 2026 | Microsoft Corporation | 18.4.3 | `2dc8badd` | `"C:\Program Files (x86)\Microsoft Visual Studio\Installer\setup.exe" uninstall --installPath "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools"` | 
