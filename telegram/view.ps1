
# View

$RefName = 'Telegram'

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
		"# {0,-25} / {1,-14} / {2} / {3} (C) {4}" -F $DisplayName, $DisplayVersion, $KeyProduct, $Exe, $Publisher
	} | Sort-Object

Read-Host “Press ENTER to exit...”

Return

# Telegram Desktop 4.9.9    / 4.9.9          / Telegram Desktop / C:\Program Files\Telegram Desktop\uninstall.bat (C) Telegram FZ-LLC
# Telegram Desktop          / 4.9.9          / {53F49750-6209-4FBF-9CA8-7A333C87D1ED}_is1 / "C:\Users\XXXXX\AppData\Roaming\Telegram Desktop\unins000.exe" (C) Telegram FZ-LLC
