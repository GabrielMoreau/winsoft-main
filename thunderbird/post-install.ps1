

# Clean old empty key with Thunderbird OCS in the name (specific LEGI)

@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") | 
	Where { $_.Name -match 'Thunderbird' } |
	ForEach {
		$App = (Get-ItemProperty -Path $_.PSPath)
		$VersionMajor = $App.VersionMajor
		$VersionMinor = $App.VersionMinor
		$Exe = $App.UninstallString
		$Display = $App.DisplayName
		If ($Display -match 'Thunderbird.*OCS') {
			$KeyPath = $App.PSPath
			Remove-Item -Path "$KeyPath" -Force -Recurse -ErrorAction SilentlyContinue
		}
	}

