
# View

$RefName = 'RStudio'

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
		"# {0,-22} / {1,-14} / {2} / {3} (C) {4}" -F $DisplayName, $DisplayVersion, $KeyProduct, $Exe, $Publisher
	} | Sort-Object

$RefName = 'R for Windows'

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
		"# {0,-22} / {1,-14} / {2} / {3} (C) {4}" -F $DisplayName, $DisplayVersion, $KeyProduct, $Exe, $Publisher
	} | Sort-Object

Read-Host “Press ENTER to exit...”

Return

# RStudio                / 2023.06.2+561  / RStudio / C:\Program Files\RStudio\Uninstall.exe (C) Posit Software
# R for Windows 4.3.0    / 4.3.0          / R for Windows 4.3.0_is1 / "C:\Program Files\R\R-4.3.0\unins000.exe" (C) R Core Team
# R for Windows 4.3.1    / 4.3.1          / R for Windows 4.3.1_is1 / "C:\Program Files\R\R-4.3.1\unins000.exe" (C) R Core Team
