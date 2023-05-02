
$Flag2022x86 = ''
$Flag2022x64 = ''
$RefName = 'Microsoft Visual C++ Redistributable'

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

			If ($DisplayName -match '2008.*x64') {
				If ($DisplayVersion -lt [version]'__2008-x64__') {
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
				If ($DisplayVersion -lt [version]'__2008-x64__') {
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
				If ($DisplayVersion -lt [version]'__2010-x64__') {
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
				If ($DisplayVersion -lt [version]'__2010-x86__') {
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
				If ($DisplayVersion -lt [version]'__2012-x64__') {
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
				If ($DisplayVersion -lt [version]'__2012-x86__') {
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
				If ($DisplayVersion -lt [version]'__2013-x64__') {
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
				If ($DisplayVersion -lt [version]'__2013-x86__') {
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
				If ($DisplayVersion -lt [version]'__2015-2019-x64__') {
					$Exe = '2015-2019\vc_redist.x64.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2015-2019 (x64) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2015-2019 (x64) redistributable already at version $DisplayVersion or higher"
				}
			}
			ElseIf ($DisplayName -match '(2015-2019|\s2015\s|\s2017\s).*x86') {
				If ($DisplayVersion -lt [version]'__2015-2019-x64__') {
					$Exe = '2015-2019\vc_redist.x86.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2015-2019 (x86) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2015-2019 (x86) redistributable already at version $DisplayVersion or higher"
				}
			}

			ElseIf ($DisplayName -match '2015-2022.*x64') {
				If ($DisplayVersion -lt [version]'__2015-2022-x64__') {
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
							Write-Output "Error: $RefName uninstall return code $($Proc.ExitCode)"
							Return
						} Else {
							$Flag2022x64 = 'installed'
						}
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2015-2022 (x64) redistributable already at version $DisplayVersion or higher"
					$Flag2022x64 = 'installed'
				}
			}
			ElseIf ($DisplayName -match '2015-2022.*x86') {
				If ($DisplayVersion -lt [version]'__2015-2022-x86__') {
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
							Write-Output "Error: $RefName uninstall return code $($Proc.ExitCode)"
							Return
						} Else {
							$Flag2022x86 = 'installed'
						}
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2015-2022 (x86) redistributable already at version $DisplayVersion or higher"
					$Flag2022x86 = 'installed'
				}
			}
		}
	}

# Clean old version
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match 'Microsoft Visual .* Redistributable')) { Return }

		If ((($DisplayName -match '(2015-2019|2015-2022|\s2015\s|\s2017\s).*x64') -And ($Flag2022x64 -eq 'installed')) -Or (($DisplayName -match '(2015-2019|2015-2022|\s2015\s|\s2017\s).*x86') -And ($Flag2022x86 -eq 'installed'))) {
			$UninstallString = $App.UninstallString
			If (!($UninstallString -match 'VC_redist.*.exe')) { Return }

			[version]$DisplayVersion = $App.DisplayVersion
			If (($DisplayName -match '2015-2022.*x64') -And (!($DisplayVersion -lt [version]'__2015-2022-x64__'))) { Return }
			If (($DisplayName -match '2015-2022.*x86') -And (!($DisplayVersion -lt [version]'__2015-2022-x86__'))) { Return }

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
