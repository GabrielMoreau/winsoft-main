
# View

$RefName = 'FreeCAD'

@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall";
  Get-ChildItem -Recurse "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$Publisher = $App.Publisher
		$KeyProduct = $Key | Split-Path -Leaf
		$Exe = $App.UninstallString
		"# {0,-30} / {1,-14} / {2} / {3} (C) {4}" -F $DisplayName, $DisplayVersion, $KeyProduct, $Exe, $Publisher
	} | Sort-Object

Read-Host “Press ENTER to exit...”

Return

# FreeCAD 0.20.2                 / 0.20.2         / FreeCAD0202 / "C:\Program Files\FreeCAD 0.20\Uninstall-FreeCAD.exe" (C) FreeCAD Team
# FreeCAD 0.21.0                 / 0.21.0         / FreeCAD0210 / "C:\Program Files\FreeCAD 0.21\Uninstall-FreeCAD.exe" (C) FreeCAD Team
