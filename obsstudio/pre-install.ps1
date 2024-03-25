
Write-Output "Begin Pre-Install"

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

			If ($DisplayName -match '2015-2022.*x64') {
				If ($DisplayVersion -lt [version]'__2015-2022-x64__') {
					If ($ToDo -eq 'unknown') {
						Write-Output "Warning: Microsoft Visual C++ 2015-2022 (x64) Redistributable already installed but too old"
						$ToDo = 'install-2022'
					}
				} Else {
					Write-Output "Info: Microsoft Visual C++ 2015-2022 (x64) Redistributable already setup"
					$ToDo = 'already-setup'
				}
			}
		}
	}

If ($ToDo -eq 'unknown') {
	Write-Output "Warning: Microsoft Visual C++ 2015-2022 (x64) Redistributable not pre-installed"
	$ToDo = 'install-2022'
}

If ($ToDo -eq 'install-2022') {
	$Exe = '2015-2022\vc_redist.x64.exe'
	$Args = '/install /quiet /norestart'
	If (Test-Path -Path "$Exe") {
		Write-Output "Info: Update (or install) Microsoft Visual C++ 2015-2022 (x64) redistributable"
		Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -Wait
	}
}
