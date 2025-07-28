
Write-Output "Begin Pre-Install"

# Remove Teams Machine-Wide Installer
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If ($DisplayName -match 'Teams Machine-Wide Installer') {
			[version]$DisplayVersion = $App.DisplayVersion
			$KeyProduct = $Key | Split-Path -Leaf
			#$UninstallString = $App.UninstallString
			$UninstallSplit = $App.UninstallString -Split "/I"
			$Args = '/x "' + $UninstallSplit[1].Trim() + '" /qn /norestart'
			Write-Output "Info1: $DisplayName / $DisplayVersion / $KeyProduct/ $Args"

			$Proc = Start-Process -FilePath "MsiExec.exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru

			$Timeouted = $Null # Reset any previously set timeout
			# Wait up to 180 seconds for normal termination
			$Proc | Wait-Process -Timeout 300 -ErrorAction SilentlyContinue -ErrorVariable Timeouted
			If ($Timeouted) {
				# Terminate the process
				$Proc | Kill
				Write-Output "Error: kill Teams Machine-Wide uninstall exe"
				Return
			} ElseIf ($Proc.ExitCode -ne 0) {
				Write-Output "Error: Teams Machine-Wide uninstall return code $($Proc.ExitCode)"
				Return
			}
		}
	}

$LogDir = "__LOGDIR__"
Write-Output "Info: Log dir $LogDir"

# Remove Microsoft Teams Meeting Add-in for Microsoft Office
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If ($DisplayName -match 'Microsoft Teams Meeting Add-in for Microsoft Office') {
			[version]$DisplayVersion = $App.DisplayVersion
			$KeyProduct = $Key | Split-Path -Leaf
			#$UninstallString = $App.UninstallString
			$UninstallSplit = $App.UninstallString -Split "/I"
			$Args = '/x "' + $UninstallSplit[1].Trim() + '" /quiet InstallerVersion=v3 /l "$LogDir\MSTeams-PreInstall-MSI.log"'
			Write-Output "Info2: $DisplayName / $DisplayVersion / $KeyProduct/ $Args"

			$Proc = Start-Process -FilePath "MsiExec.exe" -ArgumentList "$Args" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru

			$Timeouted = $Null # Reset any previously set timeout
			# Wait up to 180 seconds for normal termination
			$Proc | Wait-Process -Timeout 300 -ErrorAction SilentlyContinue -ErrorVariable Timeouted
			If ($Timeouted) {
				# Terminate the process
				$Proc | Kill
				Write-Output "Error: kill Microsoft Teams Meeting Add-in for Microsoft Office uninstall exe"
				Return
			} ElseIf ($Proc.ExitCode -ne 0) {
				Write-Output "Error: Microsoft Teams Meeting Add-in for Microsoft Office uninstall return code $($Proc.ExitCode)"
				Return
			}
		}
	}

# Remove previous Appx Package
Get-AppxPackage -Name MSTeams -AllUsers | Remove-AppxPackage -AllUsers


# Do not continue after this line
Exit


# Remove User Local Teams
ForEach ($User in (Get-ChildItem C:\Users)) {
	$TeamsLocal = "$($User.FullName)\AppData\Local\Microsoft\Teams"
	If (Test-Path $TeamsLocal) {
		$UnInstall = Get-ChildItem -Path "$TeamsLocal\*" -Include Update.exe -Recurse -ErrorAction SilentlyContinue
		If ($UnInstall.Exists) {
			Write-Output "Info: Found $($UnInstall.FullName), now uninstall"
			Start-Process "$UnInstall" -ArgumentList "--uninstall -s" -Wait -NoNewWindow
			Start-Sleep -Seconds 5
			# Cleanup Microsoft Teams Application (Local User Profile) Directory
			If (Test-Path $TeamsLocal) {
				Write-Output "Info: Cleanup ($TeamsLocal) Directory."
				Remove-Item -Path "$TeamsLocal" -Force -Recurse -ErrorAction SilentlyContinue
			}
			# Remove Microsoft Teams Start Menu Shortcut From All Profiles
			$StartMenuSC = "$($User.FullName)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft*Teams*"
			If (Test-Path $StartMenuSC) {
				Write-Output "Info: Cleanup StartMenu for $($User.Name)"
				Remove-Item $StartMenuSC -Recurse -Force -ErrorAction SilentlyContinue
			}
			# Remove Microsoft Teams Shortcuts From All Profiles
			$DesktopSC = "$($User.FullName)\Desktop\Microsoft*Teams*.lnk"
			If (Test-Path $DesktopSC) {
				Write-Output "Info: Cleanup Shortcuts for $($User.Name)"
				Remove-Item $DesktopSC -Recurse -Force -ErrorAction SilentlyContinue
			}
		}
	}
}

$RefName = 'Teams'
# View all Zoom
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf
		Write-Output "Installed: $DisplayName / $DisplayVersion / $KeyProduct / $($App.UninstallString)"
	}


Write-Output "Checking For Global Installation Of Microsoft Teams..."

# Minimum Required Version
$MinVersion = [Version]"__VERSION__"
$Found = $False

# Only Check For Exact DisplayName "MSTeams"
$GlobalPackages = Get-ProvisionedAppxPackage -Online | Where-Object DisplayName -Eq "MSTeams"
ForEach ($Pkg In $GlobalPackages) {
	Try {
		$CurrentVersion = [Version]$Pkg.Version
		If ($CurrentVersion -Ge $MinVersion) {
			Write-Output "Found MSTeams Version $($Pkg.Version) (>= $MinVersion)"
			$Found = $True
		}
		Else {
			Write-Output "Found MSTeams Version $($Pkg.Version), But It's Too Old."
		}
	}
	Catch {
		Write-Output "Could Not Parse Version: $($Pkg.Version)"
	}
}

If ($Found) {
	Write-Output "MSTeams Is Installed Globally And Up-To-Date."
	Exit 0
}
Else {
	Write-Output "MSTeams Is Not Installed Globally Or Version Is Too Old."
	Exit 1
}
