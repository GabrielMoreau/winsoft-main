
# Clean old empty key with Thunderbird OCS in the name (specific LEGI)
#@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
#  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | 
#	Where { $_.Name -match 'Thunderbird' } |
#	ForEach {
#		$App = (Get-ItemProperty -Path $_.PSPath)
#		$VersionMajor = $App.VersionMajor
#		$VersionMinor = $App.VersionMinor
#		$Exe = $App.UninstallString
#		$Display = $App.DisplayName
#		If ($Display -match 'Thunderbird.*OCS') {
#			$KeyPath = $App.PSPath
#			Remove-Item -Path "$KeyPath" -Force -Recurse -ErrorAction SilentlyContinue
#		}
#	}

# Clean old duplicate key with Thunderbird in the name (same uninstall string)

$RefVersion = '91.5.1'
$RefUninstallString = ''

Function ToVersion {
	Param (
		[Parameter(Mandatory = $true)] [string]$Version
	)

	Return [version]($Version -Replace '[^\d\.].*$', '')
}

@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | 
	Where { $_.Name -match 'Thunderbird' } |
	ForEach {
		$App = (Get-ItemProperty -Path $_.PSPath)
		$DisplayVersion = $App.DisplayVersion
		$Exe = $App.UninstallString
		$DisplayName = $App.DisplayName
		#Echo $DisplayName $DisplayVersion $Exe
		If ((ToVersion($DisplayVersion)) -eq [version]$RefVersion) {
			$RefUninstallString = $Exe
			$KeyPath = $App.PSPath
			Echo "Ref Key $DisplayName / $Exe / $KeyPath"
			}
	}

If ($RefUninstallString -ne '') {
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | 
		Where { $_.Name -match 'Thunderbird' } |
		ForEach {
			$App = (Get-ItemProperty -Path $_.PSPath)
			$DisplayVersion = $App.DisplayVersion
			$Exe = $App.UninstallString
			$DisplayName = $App.DisplayName
			# Echo "Check Key $DisplayName : $DisplayVersion < $RefVersion ?"
			If (($Exe -eq $RefUninstallString) -And ((ToVersion($DisplayVersion)) -lt [version]$RefVersion)) {
				$KeyPath = $App.PSPath
				Echo "Remove Key $DisplayName / $Exe / $KeyPath"
				Remove-Item -Path "$KeyPath" -Force -Recurse -ErrorAction SilentlyContinue
			}
		}
}
