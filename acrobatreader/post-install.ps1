
Write-Output "Begin Post-Install"

Write-Output "Stop Adobe Update Service"
# Status  | Name            | DisplayName
# Running | AdobeARMservice | Adobe Acrobat Update Service
Get-Service -Name "AdobeARMservice" -ErrorAction SilentlyContinue | Stop-Service
Get-Service -Name "AdobeARMservice" -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled
Get-Service -Name "AdobeARMservice" -ErrorAction SilentlyContinue | Select-Object Name, StartType, Status

$RefName = 'Adobe Acrobat .64-bit'
# View
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf
		Write-Output "Installed: $DisplayName / $DisplayVersion / $KeyProduct / $($App.UninstallString)"
	}
