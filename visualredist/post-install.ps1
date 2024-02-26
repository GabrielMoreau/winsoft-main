
Write-Output "Begin Post-Install"

$Flag2022x86 = ''
$Flag2022x64 = ''
$RefName = 'Microsoft Visual C++ Redistributable'

Function ToVersion {
	Param (
		[Parameter(Mandatory = $true)] [string]$Version
	)

	$Version = $Version -Replace '[^\d\.].*$', ''
	$Version = $Version -Replace '\.00?$', ''
	$Version = $Version -Replace '\.00?$', ''
	Return [version]$Version
}

# Install last version
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If ($DisplayName -match 'Microsoft Visual .* Redistributable') {
			$DisplayVersion = $App.DisplayVersion
			$KeyProduct = $Key | Split-Path -Leaf
			Write-Output "Info: $DisplayName / $DisplayVersion / $KeyProduct"

			If ($DisplayName -match '2005.*x64') {
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2005-x64__'))) {
					$Exe = '2005\vcredist_x64.EXE'
					$Args = '/Q'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2005 (x64) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2005 (x64) redistributable already at version $DisplayVersion or higher"
				}
			}
			ElseIf ($DisplayName -match '2005.*x86') {
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2005-x64__'))) {
					$Exe = '2005\vcredist_x86.EXE'
					$Args = '/Q'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2005 (x86) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2005 (x86) redistributable already at version $DisplayVersion or higher"
				}
			}

			If ($DisplayName -match '2008.*x64') {
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2008-x64__'))) {
					$Exe = '2008\vcredist_x64.exe'
					$Args = '/q'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2008 (x64) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2008 (x64) redistributable already at version $DisplayVersion or higher"
				}
			}
			ElseIf ($DisplayName -match '2008.*x86') {
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2008-x64__'))) {
					$Exe = '2008\vcredist_x86.exe'
					$Args = '/q'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2008 (x86) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2008 (x86) redistributable already at version $DisplayVersion or higher"
				}
			}

			ElseIf ($DisplayName -match '2010.*x64') {
				# 10.0.40219.325
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2010-x64__'))) {
					$Exe = '2010\vcredist_x64.exe'
					$Args = '/q /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2010 (x64) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2010 (x64) redistributable already at version $DisplayVersion or higher"
				}
			}
			ElseIf ($DisplayName -match '2010.*x86') {
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2010-x86__'))) {
					$Exe = '2010\vcredist_x86.exe'
					$Args = '/q /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2010 (x86) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2010 (x86) redistributable already at version $DisplayVersion or higher"
				}
			}

			ElseIf ($DisplayName -match '2012.*x64') {
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2012-x64__'))) {
					$Exe = '2012\vcredist_x64.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2012 (x64) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2012 (x64) redistributable already at version $DisplayVersion or higher"
				}
			}
			ElseIf ($DisplayName -match '2012.*x86') {
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2012-x86__'))) {
					$Exe = '2012\vcredist_x86.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2012 (x86) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2012 (x86) redistributable already at version $DisplayVersion or higher"
				}
			}

			ElseIf ($DisplayName -match '2013.*x64') {
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2013-x64__'))) {
					$Exe = '2013\vcredist_x64.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2013 (x64) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2013 (x64) redistributable already at version $DisplayVersion or higher"
				}
			}
			ElseIf ($DisplayName -match '2013.*x86') {
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2013-x86__'))) {
					$Exe = '2013\vcredist_x86.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2013 (x86) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2013 (x86) redistributable already at version $DisplayVersion or higher"
				}
			}

			ElseIf ($DisplayName -match '(2015-2019|\s2015\s|\s2017\s).*x64') {
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2015-2022-x64__'))) {
					$Exe = '2015-2022\vc_redist.x64.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2015-2022 (x64) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2015-2022 (x64) redistributable already at version $DisplayVersion or higher"
				}
			}
			ElseIf ($DisplayName -match '(2015-2019|\s2015\s|\s2017\s).*x86') {
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2015-2022-x64__'))) {
					$Exe = '2015-2022\vc_redist.x86.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2015-2022 (x86) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2015-2022 (x86) redistributable already at version $DisplayVersion or higher"
				}
			}

			ElseIf ($DisplayName -match '2015-2022.*x64') {
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2015-2022-x64__'))) {
					$Exe = '2015-2022\vc_redist.x64.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2015-2022 (x64) redistributable"
						$Proc = Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru
						$Timeouted = $Null # Reset any previously set timeout
						# Wait up to 180 seconds for normal termination
						$Proc | Wait-Process -Timeout 300 -ErrorAction SilentlyContinue -ErrorVariable Timeouted
						If ($Timeouted) {
							# Terminate the process
							$Proc | Kill
							Write-Output "Error: kill $RefName vc_redist.x86 exe"
							Return
						} ElseIf ($Proc.ExitCode -ne 0) {
							Write-Output "Error: $RefName install return code $($Proc.ExitCode)"
							Return
						}
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2015-2022 (x64) redistributable already at version $DisplayVersion or higher"
				}
			}

			ElseIf ($DisplayName -match '2015-2022.*x86') {
				If ((ToVersion($DisplayVersion)) -lt (ToVersion('__2015-2022-x86__'))) {
					$Exe = '2015-2022\vc_redist.x86.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2015-2022 (x86) redistributable"
						$Proc = Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru
						$Timeouted = $Null # Reset any previously set timeout
						# Wait up to 180 seconds for normal termination
						$Proc | Wait-Process -Timeout 300 -ErrorAction SilentlyContinue -ErrorVariable Timeouted
						If ($Timeouted) {
							# Terminate the process
							$Proc | Kill
							Write-Output "Error: kill $RefName vc_redist.x86 exe"
							Return
						} ElseIf ($Proc.ExitCode -ne 0) {
							Write-Output "Error: $RefName install return code $($Proc.ExitCode)"
							Return
						}
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2015-2022 (x86) redistributable already at version $DisplayVersion or higher"
				}
			}
		}
	}

# View all version and set flag
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match 'Microsoft Visual .* Redistributable')) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf
		$Exe = $App.UninstallString
		"# {0,-66} / {1,-14} / {2} / {3}" -F $DisplayName, $DisplayVersion, $KeyProduct, $Exe

		If (($DisplayName -match '2015-2022.*x86') -And ((ToVersion($DisplayVersion)) -ge (ToVersion('__2015-2022-x86__')))) { $Flag2022x86 = 'installed' }
		If (($DisplayName -match '2015-2022.*x64') -And ((ToVersion($DisplayVersion)) -ge (ToVersion('__2015-2022-x64__')))) { $Flag2022x64 = 'installed' }
	} | Sort-Object

# Uninstall old version
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match 'Microsoft Visual .* Redistributable')) { Return }

		If ((($DisplayName -match '(2015-2019|2015-2022|\s2015\s|\s2017\s).*x64') -And ($Flag2022x64 -eq 'installed')) -Or (($DisplayName -match '(2015-2019|2015-2022|\s2015\s|\s2017\s).*x86') -And ($Flag2022x86 -eq 'installed'))) {
			$DisplayVersion  = $App.DisplayVersion
			$UninstallString = $App.UninstallString

			If (($DisplayName -match '2015-2022.*x64') -And ((ToVersion($DisplayVersion)) -ge (ToVersion('__2015-2022-x64__')))) { Return }
			If (($DisplayName -match '2015-2022.*x86') -And ((ToVersion($DisplayVersion)) -ge (ToVersion('__2015-2022-x86__')))) { Return }

			If (!($UninstallString -match 'VC_redist.*.exe')) {
				$KeyProduct = $Key | Split-Path -Leaf
				Write-Output "Error: HowTo Remove $DisplayName / $DisplayVersion / $KeyProduct / $UninstallString"
				Return
			}

			$UninstallSplit = $App.UninstallString -Split "exe"
			$Exe = $UninstallSplit[0] + 'exe"'
			$Args = '/uninstall /quiet /norestart'
			Write-Output "Remove: $DisplayName / $DisplayVersion / $Exe / $Args"

			$Proc = Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru

			$Timeouted = $Null # Reset any previously set timeout
			# Wait up to 180 seconds for normal termination
			$Proc | Wait-Process -Timeout 300 -ErrorAction SilentlyContinue -ErrorVariable Timeouted
			If ($Timeouted) {
				# Terminate the process
				$Proc | Kill
				Write-Output "Error: kill $RefName uninstall exe"
				Return
			} ElseIf ($Proc.ExitCode -ne 0) {
				Write-Output "Error: $RefName uninstall return code $($Proc.ExitCode)"
				Return
			}
		}
	}
