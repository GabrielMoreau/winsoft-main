
# View

$RefName = 'ParaView'

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

# ParaView             / 5.11.0         / {76D57FB1-0CD5-40A2-9296-16B85344BCAA} / MsiExec.exe /X{76D57FB1-0CD5-40A2-9296-16B85344BCAA} (C) Kitware, Inc.
