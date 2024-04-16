
Write-Output "Begin Post-Install"

$RefName = 'Microsoft Windows Desktop Runtime'

# Transform string to a version object
Function ToVersion {
	Param (
		[Parameter(Mandatory = $true)] [string]$Version
	)

	$Version = $Version -Replace '[^\d\.].*$', ''
	$Version = "$Version.0.0.0"
	$Version = $Version -Replace '\.+',     '.'
	$Version = $Version -Replace '\.0+',    '.0'
	$Version = $Version -Replace '\.0(\d)', '.$1'
	$Version = $Version.Split('.')[0,1,2,3] -Join '.'
	Return [version]$Version
}

# Install last version
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf
		$Uninstall = $App.UninstallString
		Write-Output "Info: $DisplayName / $DisplayVersion / $KeyProduct / $Uninstall"

		# Only register Key with nice version number
		If ($Uninstall -match '^MsiExec.exe') { Return }

		If ($DisplayName -match 'Runtime - 5\..*x64') {
			If ((ToVersion($DisplayVersion)) -lt (ToVersion('__VERSION5__'))) {
				$Exe = 'windowsdesktop-runtime-__VERSION5__-win-x64.exe'
				$Args = '/install /quiet /norestart'
				If (Test-Path -Path "$Exe") {
					Write-Output "Warn: Update $RefName $DisplayVersion to version __VERSION5__"
					Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
				}
			} Else {
				Write-Output "Note: $RefName already at version $DisplayVersion (>= __VERSION5__)"
			}
		}
		ElseIf ($DisplayName -match 'Runtime - 6\..*x64') {
			If ((ToVersion($DisplayVersion)) -lt (ToVersion('__VERSION6__'))) {
				$Exe = 'windowsdesktop-runtime-__VERSION6__-win-x64.exe'
				$Args = '/install /quiet /norestart'
				If (Test-Path -Path "$Exe") {
					Write-Output "Warn: Update $RefName $DisplayVersion to version __VERSION6__"
					Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
				}
			} Else {
				Write-Output "Note: $RefName already at version $DisplayVersion (>= __VERSION6__)"
			}
		}
		ElseIf ($DisplayName -match 'Runtime - 7\..*x64') {
			If ((ToVersion($DisplayVersion)) -lt (ToVersion('__VERSION7__'))) {
				$Exe = 'windowsdesktop-runtime-__VERSION7__-win-x64.exe'
				$Args = '/install /quiet /norestart'
				If (Test-Path -Path "$Exe") {
					Write-Output "Warn: Update $RefName $DisplayVersion to version __VERSION7__"
					Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
				}
			} Else {
				Write-Output "Note: $RefName already at version $DisplayVersion (>= __VERSION7__)"
			}
		}
		ElseIf ($DisplayName -match 'Runtime - 8\..*x64') {
			If ((ToVersion($DisplayVersion)) -lt (ToVersion('__VERSION8__'))) {
				$Exe = 'windowsdesktop-runtime-__VERSION8__-win-x64.exe'
				$Args = '/install /quiet /norestart'
				If (Test-Path -Path "$Exe") {
					Write-Output "Warn: Update $RefName $DisplayVersion to version __VERSION8__"
					Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
				}
			} Else {
				Write-Output "Note: $RefName already at version $DisplayVersion (>= __VERSION8__)"
			}
		}
	}

# View all version
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf
		$Exe = $App.UninstallString
		"View: {0,-56} / {1,-14} / {2} / {3}" -F $DisplayName, $DisplayVersion, $KeyProduct, $Exe
	} | Sort-Object


# Microsoft Windows Desktop Runtime - 6.0.29 (x64)                   / 48.116.12057   / {A0DA3EDD-9C41-491F-A77E-5F90AFDB64B2} / MsiExec.exe /X{A0DA3EDD-9C41-491F-A77E-5F90AFDB64B2}
# Microsoft Windows Desktop Runtime - 6.0.29 (x64)                   / 6.0.29.33521   / {54679abd-8ed9-4bd3-8400-7684dd7c6f03} / "C:\ProgramData\Package Cache\{54679abd-8ed9-4bd3-8400-7684dd7c6f03}\windowsdesktop-runtime-6.0.29-win-x64.exe"  /uninstall
# Microsoft Windows Desktop Runtime - 7.0.18 (x64)                   / 56.72.12035    / {F91C5C9A-FDEF-44D0-88D8-40113345FAA7} / MsiExec.exe /X{F91C5C9A-FDEF-44D0-88D8-40113345FAA7}
# Microsoft Windows Desktop Runtime - 7.0.18 (x64)                   / 7.0.18.33520   / {9926fb6d-a007-472d-b0dc-38d7e8c475e0} / "C:\ProgramData\Package Cache\{9926fb6d-a007-472d-b0dc-38d7e8c475e0}\windowsdesktop-runtime-7.0.18-win-x64.exe"  /uninstall
# Microsoft Windows Desktop Runtime - 8.0.4 (x64)                    / 64.16.12024    / {4B91040F-9192-4D51-B1CE-36B959846C8D} / MsiExec.exe /X{4B91040F-9192-4D51-B1CE-36B959846C8D}
# Microsoft Windows Desktop Runtime - 8.0.4 (x64)                    / 8.0.4.33519    / {93344293-35c0-4560-8a6c-1b06afd31de4} / "C:\ProgramData\Package Cache\{93344293-35c0-4560-8a6c-1b06afd31de4}\windowsdesktop-runtime-8.0.4-win-x64.exe"  /uninstall
