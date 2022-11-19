
$ToDo = 'unknown'

@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If ($DisplayName -match 'Microsoft Visual .* Redistributable') {
			[version]$DisplayVersion = $App.DisplayVersion
			$KeyProduct = $Key | Split-Path -Leaf
			#Write-Output "# $DisplayName / $DisplayVersion / $KeyProduct"

			If ($DisplayName -match '2015-2019.*x64') {
				If ($DisplayVersion -lt [version]'14.29.30139.0') {
					If ($ToDo -eq 'unknown') {
						$ToDo = 'install-2019'
					}
				} Else {
					$ToDo = 'already-setup'
				}
			}

			ElseIf ($DisplayName -match '2015-2022.*x64') {
				If ($DisplayVersion -lt [version]'14.34.31931.0') {
					If ($ToDo -eq 'unknown') {
						$ToDo = 'install-2022'
					}
				} Else {
					$ToDo = 'already-setup'
				}
			}
		}
	}

If ($ToDo -eq 'unknown') {
	$ToDo = 'install-2022'
}

If ($ToDo -eq 'install-2019') {
	$Exe = '2015-2019\vc_redist.x64.exe'
	$Args = '/install /quiet /norestart'
	If (Test-Path -Path "$Exe") {
		Write-Output "Update Microsoft Visual C++ 2015-2019 (x64) redistributable"
		Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
	}
}

ElseIf ($ToDo -eq 'install-2022') {
	$Exe = '2015-2022\vc_redist.x64.exe'
	$Args = '/install /quiet /norestart'
	If (Test-Path -Path "$Exe") {
		Write-Output "Update Microsoft Visual C++ 2015-2022 (x64) redistributable"
		Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
	}
}

