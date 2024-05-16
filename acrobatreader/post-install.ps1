
Write-Output "Begin Post-Install"

$ServiceName = "AdobeARMservice"
Write-Output "Stop $ServiceName (Adobe Update) Service"
# Status  | Name            | DisplayName
# Running | AdobeARMservice | Adobe Acrobat Update Service
Get-Service -Name "$ServiceName" -ErrorAction SilentlyContinue | Stop-Service
Get-Service -Name "$ServiceName" -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled
Get-Service -Name "$ServiceName" -ErrorAction SilentlyContinue | Select-Object Name, StartType, Status
#Try {
#	Write-Output "Remove Service $ServiceName"
#	If ((Get-Host | Select-Object -ExpandProperty Version).Major -ge 6) {
#		Remove-Service -Name "$ServiceName"
#	} Else {
#		sc.exe delete "$ServiceName"
#	}
#} Catch {
#	Write-Output "Error: $($_.exception.message)"
#}

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
