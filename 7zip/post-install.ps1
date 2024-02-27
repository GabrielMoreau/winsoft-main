
Write-Output "Begin Post-Install"

# Clean old duplicate key with 7-Zip in the name (same uninstall string)

$RefVersion = '__VERSION__'
$RefVersionShort='__VERSIONSHORT__'
$RefUninstallString = ''
$RefName = '7-Zip'

Function ToVersion {
	Param (
		[Parameter(Mandatory = $true)] [string]$Version
	)

	$Version = $Version -Replace '[^\d\.].*$', ''
	$Version = $Version -Replace '\.00?$', ''
	$Version = $Version -Replace '\.00?$', ''
	Return [version]$Version
}

@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$App = (Get-ItemProperty -Path $_.PSPath)
		$DisplayName = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }
		$DisplayVersion = $App.DisplayVersion
		$Exe = $App.UninstallString
		Write-Output "Key Item: $Name $DisplayName $DisplayVersion $Exe"
		If ((ToVersion($DisplayVersion)) -eq (ToVersion($RefVersion))) {
			$RefUninstallString = $Exe
			$KeyPath = $App.PSPath
			Write-Output "Ref Key: $DisplayName / $DisplayVersion / $Exe / $KeyPath"
			}
	}

If ($RefUninstallString -ne '') {
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
		ForEach {
			$App = (Get-ItemProperty -Path $_.PSPath)
			$DisplayName = $App.DisplayName
			If (!($DisplayName -match $RefName)) { Return }
			$DisplayVersion = $App.DisplayVersion
			$Exe = $App.UninstallString
			Write-Output "Check Key: $DisplayName : $DisplayVersion < $RefVersion ?"
			If (($Exe -eq $RefUninstallString) -And ((ToVersion($DisplayVersion)) -lt (ToVersion($RefVersion)))) {
				$KeyPath = $App.PSPath
				Write-Output "Remove Key: $DisplayName / $DisplayVersion / $Exe / $KeyPath"
				Remove-Item -Path "$KeyPath" -Force -Recurse -ErrorAction SilentlyContinue
			}
		}
}
