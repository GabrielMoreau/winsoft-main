# WinDirStat - Disk usage viewer and cleanup tool

WinDirStat is a free and open-source graphical disk usage analyzer for Microsoft Windows.

* Website : https://windirstat.net/
* Wikipedia : https://en.wikipedia.org/wiki/WinDirStat

Please note that the uninstall key is not at a standard path
```ini
[HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Uninstall\WinDirStat]
"UninstallString"="C:\\Program Files (x86)\\WinDirStat\\Uninstall.exe"
"InstallLocation"="C:\\Program Files (x86)\\WinDirStat"
"DisplayName"="WinDirStat 1.1.2"
"DisplayIcon"="C:\\Program Files (x86)\\WinDirStat\\windirstat.exe,0"
"dwVersionMajor"=dword:00000001
"dwVersionMinor"=dword:00000001
"dwVersionRev"=dword:00000002
"dwVersionBuild"=dword:0000004f
"URLInfoAbout"="http://windirstat.info/"
"NoModify"=dword:00000001
"NoRepair"=dword:00000001
```

View WinDirStat install key after our installation
```ps1
$RefName = 'WinDirStat'

@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$App = (Get-ItemProperty -Path $_.PSPath)
		$DisplayName = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }
		$DisplayVersion = $App.DisplayVersion
		$Exe = $App.UninstallString
		$KeyPath = $App.PSPath
		Echo "Ref Key $DisplayName / $DisplayVersion / $Exe / $KeyPath"
	}
```
