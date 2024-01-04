
$RefName = 'Bitvise SSH Client'
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
			$Exe = 'MsiExec.exe'
			$Args = '/x "' + $KeyProduct + '" /qn'
			Write-Output "Could-Remove: $DisplayName / $DisplayVersion / $KeyProduct / $Exe $Args"
			Return
		} Else {
			$UninstallSplit = $App.UninstallString -Split "exe"
			$Exe = $UninstallSplit[0] + 'exe"'
			$Args = '-unat "BvSshClient"'
			Write-Output "Try-Remove: $DisplayName / $DisplayVersion / $($App.UninstallString) / $Exe $Args"
		}

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
		Write-Output "Installed: $DisplayName / $DisplayVersion / $KeyProduct / $($App.UninstallString)"
	}

# HKLM	Bitvise SSH Client - FlowSshNet (x64)	Bitvise Limited	9.33.0.0	{F6213340-ED77-4314-965C-40B39B26210C}	MsiExec.exe /X{F6213340-ED77-4314-965C-40B39B26210C}
# HKLM	Bitvise SSH Client - FlowSshNet (x86)	Bitvise Limited	9.33.0.0	{4F563585-E84E-4E62-A428-D936F9A6E900}	MsiExec.exe /X{4F563585-E84E-4E62-A428-D936F9A6E900}
# HKLM	Bitvise SSH Client 9.33 (remove only)	Bitvise Limited	9.33	BvSshClient	"C:\Program Files (x86)\Bitvise SSH Client\uninst.exe" "BvSshClient"
