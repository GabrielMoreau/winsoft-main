
# View

$RefName = 'WinFsp'

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
		"# {0,-15} / {1,-14} / {2} / {3}" -F $DisplayName, $DisplayVersion, $KeyProduct, $Exe
	} | Sort-Object

Read-Host “Press ENTER to exit...”

Return


# WinFsp 2022     / 1.10.22006     / {6E315DCA-F396-4536-9FA8-616E64440FC0} / MsiExec.exe /I{6E315DCA-F396-4536-9FA8-616E64440FC0}
