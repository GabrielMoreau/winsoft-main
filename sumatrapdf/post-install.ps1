
Write-Output "Begin Post-Install"

# Clean old duplicate key with SumatraPDF in the name (same uninstall string)

$RefVersion = '__VERSION__'
$RefUninstallString = ''
$RefName = 'SumatraPDF'

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
		$KeyPath = $App.PSPath
		If ((ToVersion($DisplayVersion)) -eq (ToVersion($RefVersion))) {
			$RefUninstallString = $Exe
			Write-Output "Ref Key: $DisplayName / $DisplayVersion / $Exe / $KeyPath"
		} Else {
			Write-Output "Other Key: $DisplayName / $DisplayVersion / $Exe / $KeyPath"
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
			$KeyPath = $App.PSPath
			# Echo "Check Key $DisplayName : $DisplayVersion < $RefVersion ?"
			If ((($Exe -eq $RefUninstallString) -Or ($Exe -eq $Null)) -And ((ToVersion($DisplayVersion)) -lt (ToVersion($RefVersion)))) {
				Write-Output "Remove Key: $DisplayName / $DisplayVersion / $Exe / $KeyPath"
				Remove-Item -Path "$KeyPath" -Force -Recurse -ErrorAction SilentlyContinue
			} Else {
				Write-Output "Keep Key: $DisplayName / $DisplayVersion / $Exe / $KeyPath / $(ToVersion($DisplayVersion))"
			}
		}
}
