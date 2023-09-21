
# View

$RefName = 'Bitvise SSH Client'
# $RefName = 'Bitvise SSH Client.*remove only'

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

# Bitvise SSH Client - FlowSshNet (x64) / 9.28.0.0       / {42B2DE86-F7D1-412F-9AF3-A4561BBD837F} / MsiExec.exe /X{42B2DE86-F7D1-412F-9AF3-A4561BBD837F} (C) Bitvise Limited
# Bitvise SSH Client - FlowSshNet (x86) / 9.28.0.0       / {3723F482-A0BA-49B2-9A5D-E240705FA1C0} / MsiExec.exe /X{3723F482-A0BA-49B2-9A5D-E240705FA1C0} (C) Bitvise Limited
# Bitvise SSH Client 9.28 (remove only) / 9.28           / BvSshClient / "C:\Program Files (x86)\Bitvise SSH Client\uninst.exe" "BvSshClient" (C) Bitvise Limited

# Silent remove all three components
# "C:\Program Files (x86)\Bitvise SSH Client\uninst.exe" -unat "BvSshClient"
