
# View

$RefName = 'BalenaEtcher'

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
		"# {0,-20} / {1,-14} / {2} / {3} (C) {4}" -F $DisplayName, $DisplayVersion, $KeyProduct, $Exe, $Publisher
	} | Sort-Object

Read-Host “Press ENTER to exit...”

Return

# balenaEtcher 1.18.8  / 1.18.8         / d2f3b6c7-6f49-59e2-b8a5-f72e33900c2b / "C:\Users\XXXXX\AppData\Local\Programs\balena-etcher\Uninstall balenaEtcher.exe" /currentuser (C) Balena Ltd.
# balenaEtcher 1.18.11 / 1.18.11        / balena-etcher / C:\Program Files\balena-etcher\uninstall.bat (C) Balena Ltd.
