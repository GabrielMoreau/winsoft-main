
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
				If ($DisplayVersion -lt [version]'9.0.30729.6161') {
					$Exe = '2008\vcredist_x64.exe'
					$Args = '/q'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2008 (x64) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2008 (x64) redistributable already at version $DisplayVersion"
				}
			}
			ElseIf ($DisplayName -match '2008.*x86') {
				If ($DisplayVersion -lt [version]'9.0.30729.6161') {
					$Exe = '2008\vcredist_x86.exe'
					$Args = '/q'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2008 (x86) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2008 (x86) redistributable already at version $DisplayVersion"
				}
			}

			ElseIf ($DisplayName -match '2010.*x64') {
				# 10.0.40219.325
				If ($DisplayVersion -lt [version]'10.0.40219') {
					$Exe = '2010\vcredist_x64.exe'
					$Args = '/q /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2010 (x64) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2010 (x64) redistributable already at version $DisplayVersion"
				}
			}
			ElseIf ($DisplayName -match '2010.*x86') {
				If ($DisplayVersion -lt [version]'10.0.40219') {
					$Exe = '2010\vcredist_x86.exe'
					$Args = '/q /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2010 (x86) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2010 (x86) redistributable already at version $DisplayVersion"
				}
			}

			ElseIf ($DisplayName -match '2012.*x64') {
				If ($DisplayVersion -lt [version]'11.0.61030.0') {
					$Exe = '2012\vcredist_x64.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2012 (x64) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2012 (x64) redistributable already at version $DisplayVersion"
				}
			}
			ElseIf ($DisplayName -match '2012.*x86') {
				If ($DisplayVersion -lt [version]'11.0.61030.0') {
					$Exe = '2012\vcredist_x86.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2012 (x86) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2012 (x86) redistributable already at version $DisplayVersion"
				}
			}

			ElseIf ($DisplayName -match '2013.*x64') {
				If ($DisplayVersion -lt [version]'12.0.40664.0') {
					$Exe = '2013\vcredist_x64.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2013 (x64) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2013 (x64) redistributable already at version $DisplayVersion"
				}
			}
			ElseIf ($DisplayName -match '2013.*x86') {
				If ($DisplayVersion -lt [version]'12.0.40664.0') {
					$Exe = '2013\vcredist_x86.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2013 (x86) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2013 (x86) redistributable already at version $DisplayVersion"
				}
			}

			ElseIf ($DisplayName -match '2015-2019.*x64') {
				If ($DisplayVersion -lt [version]'14.29.30139.0') {
					$Exe = '2015-2019\vc_redist.x64.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2015-2019 (x64) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2015-2019 (x64) redistributable already at version $DisplayVersion"
				}
			}
			ElseIf ($DisplayName -match '2015-2019.*x86') {
				If ($DisplayVersion -lt [version]'14.29.30139.0') {
					$Exe = '2015-2019\vc_redist.x86.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2015-2019 (x86) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2015-2019 (x86) redistributable already at version $DisplayVersion"
				}
			}

			ElseIf ($DisplayName -match '2015-2022.*x64') {
				If ($DisplayVersion -lt [version]'14.34.31931.0') {
					$Exe = '2015-2022\vc_redist.x64.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2015-2022 (x64) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2015-2022 (x64) redistributable already at version $DisplayVersion"
				}
			}
			ElseIf ($DisplayName -match '2015-2022.*x86') {
				If ($DisplayVersion -lt [version]'14.34.31931.0') {
					$Exe = '2015-2022\vc_redist.x86.exe'
					$Args = '/install /quiet /norestart'
					If (Test-Path -Path "$Exe") {
						Write-Output "Update Microsoft Visual C++ 2015-2022 (x86) redistributable"
						Start-Process -FilePath "$Exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue'
					}
				} Else {
					Write-Output "Microsoft Visual C++ 2015-2022 (x86) redistributable already at version $DisplayVersion"
				}
			}
		}
	}
