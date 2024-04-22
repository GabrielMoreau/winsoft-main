
Write-Output "Begin Post-Install"


################################################################

# https://www.secpod.com/blog/how-to-enable-automatic-update-for-ms-office-2013-and-2016-click-to-run-installations/
# Microsoft Office Standard 2013 / Click-to-Run

# Enable
Function TweakEnableOffice2013AutoUpdate { # RESINFO
	Write-Output "Enabling MS Office2013 AutoUpdate..."
	$RefName = 'Microsoft Office Standard 2013'
	$IsInstalled = $False
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
		ForEach {
			$Key = $_
			$App = (Get-ItemProperty -Path $Key.PSPath)
			$DisplayName  = $App.DisplayName
			If ($DisplayName -match $RefName) {
				$IsInstalled = $True
			}
		}

	If ($IsInstalled -eq $True) {
		If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Office\15.0\Common\OfficeUpdate")) {
			New-Item -Path "HKLM:\Software\Policies\Microsoft\Office\15.0\Common\OfficeUpdate" -Force | Out-Null
		}
		Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Office\15.0\Common\OfficeUpdate" -Name "EnableAutomaticUpdates" -Type DWord -Value 1
	}
}

# Disable
Function TweakDisableOffice2013AutoUpdate { # RESINFO
	Write-Output "Disabling MS Office2013 AutoUpdate..."
	$RefName = 'Microsoft Office Standard 2013'
	$IsInstalled = $False
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
		ForEach {
			$Key = $_
			$App = (Get-ItemProperty -Path $Key.PSPath)
			$DisplayName  = $App.DisplayName
			If ($DisplayName -match $RefName) {
				$IsInstalled = $True
			}
		}

	If ($IsInstalled -eq $True) {
		If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Office\15.0\Common\OfficeUpdate")) {
			New-Item -Path "HKLM:\Software\Policies\Microsoft\Office\15.0\Common\OfficeUpdate" -Force | Out-Null
		}
		Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Office\15.0\Common\OfficeUpdate" -Name "EnableAutomaticUpdates" -Type DWord -Value 0
	}
}

# View
Function TweakViewOffice2013AutoUpdate {
	Write-Output "View MS Office2013 AutoUpdate (0 or not exist: No auto update, 1: auto update)"
	Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Office\15.0\Common\OfficeUpdate" -Name "EnableAutomaticUpdates" -ErrorAction SilentlyContinue
}

################################################################

# https://www.secpod.com/blog/how-to-enable-automatic-update-for-ms-office-2013-and-2016-click-to-run-installations/
# Microsoft Office Standard 2016 / Click-to-Run

# Enable
Function TweakEnableOffice2016AutoUpdate { # RESINFO
	Write-Output "Enabling MS Office2016 AutoUpdate..."
	$RefName = 'Microsoft Office Standard 2016'
	$IsInstalled = $False
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
		ForEach {
			$Key = $_
			$App = (Get-ItemProperty -Path $Key.PSPath)
			$DisplayName  = $App.DisplayName
			If ($DisplayName -match $RefName) {
				$IsInstalled = $True
			}
		}

	If ($IsInstalled -eq $True) {
		If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Office\16.0\Common\OfficeUpdate")) {
			New-Item -Path "HKLM:\Software\Policies\Microsoft\Office\16.0\Common\OfficeUpdate" -Force | Out-Null
		}
		Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Office\16.0\Common\OfficeUpdate" -Name "EnableAutomaticUpdates" -Type DWord -Value 1
	}
}

# Disable
Function TweakDisableOffice2016AutoUpdate { # RESINFO
	Write-Output "Disabling MS Office2016 AutoUpdate..."
	$RefName = 'Microsoft Office Standard 2016'
	$IsInstalled = $False
	@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
	  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
		ForEach {
			$Key = $_
			$App = (Get-ItemProperty -Path $Key.PSPath)
			$DisplayName  = $App.DisplayName
			If ($DisplayName -match $RefName) {
				$IsInstalled = $True
			}
		}

	If ($IsInstalled -eq $True) {
		If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Office\16.0\Common\OfficeUpdate")) {
			New-Item -Path "HKLM:\Software\Policies\Microsoft\Office\16.0\Common\OfficeUpdate" -Force | Out-Null
		}
		Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Office\16.0\Common\OfficeUpdate" -Name "EnableAutomaticUpdates" -Type DWord -Value 0
	}
}

# View
Function TweakViewOffice2016AutoUpdate {
	Write-Output "View MS Office2016 AutoUpdate (0 or not exist: No auto update, 1: auto update)"
	Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Office\16.0\Common\OfficeUpdate" -Name "EnableAutomaticUpdates" -ErrorAction SilentlyContinue
}

################################################################

TweakEnableOffice2013AutoUpdate
TweakEnableOffice2016AutoUpdate

TweakViewOffice2013AutoUpdate
TweakViewOffice2016AutoUpdate

################################################################
