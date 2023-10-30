
$RefName = 'UltiMaker Cura'
$RefVersion = '__VERSION__'

Function ToVersion {
	Param (
		[Parameter(Mandatory = $true)] [string]$Version
	)

	$Version = $Version -Replace '[^\d\.].*$', ''
	$Version = $Version -Replace '\.00?$', ''
	$Version = $Version -Replace '\.00?$', ''
	Return [version]$Version
}

# Remove old version
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf
		
		If ((ToVersion($DisplayVersion)) -ge (ToVersion($RefVersion))) { Return }

		If ($($App.UninstallString) -match 'MsiExec.exe') {
			$Exe = 'msiexec.exe'
			#$UninstallSplit = $App.UninstallString -Split "/I"
			#$Args = '/x "' + $UninstallSplit[1].Trim() + '" /qn /norestart'
			$Args = '/x "' + $KeyProduct + '" /qn /norestart'
			Write-Output "Remove: $DisplayName / $DisplayVersion / $KeyProduct / $Exe $Args"
		} Else { Return }

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


# View
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf
		Write-Output "Show: $DisplayName / $DisplayVersion / $KeyProduct / $($App.UninstallString)"
	}

# HKLM	UltiMaker Cura	UltiMaker	5.4.0	{7C3B43E0-0A17-4029-9146-19F3E0566B4C}	MsiExec.exe /I{7C3B43E0-0A17-4029-9146-19F3E0566B4C}
# HKLM	UltiMaker Cura	UltiMaker	5.5.0	{3AC2EF24-9745-4516-BF41-85F9223E03F7}	MsiExec.exe /I{3AC2EF24-9745-4516-BF41-85F9223E03F7}
