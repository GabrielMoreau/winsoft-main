# View Visual C++ Redistributable package

$RefName = 'Microsoft Visual .* Redistributable'
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


# Microsoft Visual C++ 2008 Redistributable - x64 9.0.30729.6161     / 9.0.30729.6161 / {5FCE6D76-F5DC-37AB-B2B8-22AB8CEDB1D4} / MsiExec.exe /X{5FCE6D76-F5DC-37AB-B2B8-22AB8CEDB1D4}
# Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.6161     / 9.0.30729.6161 / {9BE518E6-ECC6-35A9-88E4-87755C07200F} / MsiExec.exe /X{9BE518E6-ECC6-35A9-88E4-87755C07200F}
# Microsoft Visual C++ 2010  x64 Redistributable - 10.0.40219        / 10.0.40219     / {1D8E6291-B0D5-35EC-8441-6616F567A0F7} / MsiExec.exe /X{1D8E6291-B0D5-35EC-8441-6616F567A0F7}
# Microsoft Visual C++ 2010  x86 Redistributable - 10.0.40219        / 10.0.40219     / {F0C3E5D1-1ADE-321E-8167-68EF0DE699A5} / MsiExec.exe /X{F0C3E5D1-1ADE-321E-8167-68EF0DE699A5}
# Microsoft Visual C++ 2015-2019 Redistributable (x86) - 14.29.30139 / 14.29.30139.0  / {8d5fdf81-7022-423f-bd8b-b513a1050ae1} / "C:\ProgramData\Package Cache\{8d5fdf81-7022-423f-bd8b-b513a1050ae1}\VC_redist.x86.exe"  /uninstall
# Microsoft Visual C++ 2015-2022 Redistributable (x64) - 14.34.31938 / 14.34.31938.0  / {d92971ab-f030-43c8-8545-c66c818d0e05} / "C:\ProgramData\Package Cache\{d92971ab-f030-43c8-8545-c66c818d0e05}\VC_redist.x64.exe"  /uninstall
