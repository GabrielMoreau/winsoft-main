
Write-Output "Begin Post-Install"

# Clean old duplicate key with digiKam in the name (same uninstall string)

$RefVersion = '__VERSION__'
$RefUninstallString = ''

@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	Where { $_.Name -match 'digiKam' } |
	ForEach {
		$App = (Get-ItemProperty -Path $_.PSPath)
		$DisplayVersion = $App.DisplayVersion
		$Exe = $App.UninstallString
		$DisplayName = $App.DisplayName
		# Echo $DisplayName $DisplayVersion $Exe
		If ([version]$DisplayVersion -eq [version]$RefVersion) {
			$RefUninstallString = $Exe
			$KeyPath = $App.PSPath
			Write-Output "Ref Key: $DisplayName / $Exe / $KeyPath"
			}
	}

If ($RefUninstallString -ne '') {
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
		Where { $_.Name -match 'digiKam' } |
		ForEach {
			$App = (Get-ItemProperty -Path $_.PSPath)
			$DisplayVersion = $App.DisplayVersion
			$Exe = $App.UninstallString
			$DisplayName = $App.DisplayName
			# Echo "Check Key $DisplayName : $DisplayVersion < $RefVersion ?"
			If (($Exe -eq $RefUninstallString) -And ([version]$DisplayVersion -lt [version]$RefVersion)) {
				$KeyPath = $App.PSPath
				Write-Output "Remove Key: $DisplayName / $Exe / $KeyPath"
				Remove-Item -Path "$KeyPath" -Force -Recurse -ErrorAction SilentlyContinue
			}
		}
}
