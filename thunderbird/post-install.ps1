
# Clean old duplicate key with Thunderbird in the name (same uninstall string)

$RefVersion = '91.5.1'
$RefUninstallString = ''
$RefName = 'Thunderbird'

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
		#Echo '++++++++' $Name $DisplayName $DisplayVersion $Exe
		If ((ToVersion($DisplayVersion)) -eq (ToVersion($RefVersion))) {
			$RefUninstallString = $Exe
			$KeyPath = $App.PSPath
			Echo "Ref Key $DisplayName / $DisplayVersion / $Exe / $KeyPath"
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
			# Echo "Check Key $DisplayName : $DisplayVersion < $RefVersion ?"
			If (($Exe -eq $RefUninstallString) -And ((ToVersion($DisplayVersion)) -lt (ToVersion($RefVersion)))) {
				$KeyPath = $App.PSPath
				Echo "Remove Key $DisplayName / $DisplayVersion / $Exe / $KeyPath"
				Remove-Item -Path "$KeyPath" -Force -Recurse -ErrorAction SilentlyContinue
			}
		}
}
