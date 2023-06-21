
# View

$RefName = 'Ultracopier'

@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf
		$Exe = $App.UninstallString
		"# {0,-66} / {1,-14} / {2} / {3}" -F $DisplayName, $DisplayVersion, $KeyProduct, $Exe
	} | Sort-Object

Read-Host “Press ENTER to exit...”

Return
