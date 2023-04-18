
$RefName = 'Adobe Flash Player'

# View
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If ($DisplayName -match $RefName) {
			$DisplayVersion = $App.DisplayVersion
			$UninstallString = $App.UninstallString
			$KeyProduct = $Key | Split-Path -Leaf
			"# {0,-66} / {1,-14} / {2} / {3}" -F $DisplayName, $DisplayVersion, $KeyProduct, $UninstallString
		}
	}

# Remove Key
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If ($DisplayName -match $RefName) {
			$DisplayVersion = $App.DisplayVersion
			$UninstallString = $App.UninstallString
			If (!$UninstallString) {
				# Old empty key
				Write-Output "# RemoveKey $RefName version $DisplayVersion / $($Key.PSPath)"
				Remove-Item -Path "$($Key.PSPath)" -Recurse -ErrorAction SilentlyContinue
				Return
			}
		}
	}
