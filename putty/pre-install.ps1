
Write-Output "Begin Pre-Install"

$RefName = '^PuTTY '

# Run MSI or EXE with timeout control
Function Run-Exec {
	Param (
		[Parameter(Mandatory = $True)] [string]$Name,
		[Parameter(Mandatory = $True)] [string]$FilePath,
		[Parameter(Mandatory = $True)] [string]$ArgumentList,
		[Parameter(Mandatory = $False)] [int]$Timeout = 300
	)

	$Proc = Start-Process -FilePath "$FilePath" -ArgumentList "$ArgumentList" -WindowStyle 'Hidden' -ErrorAction 'SilentlyContinue' -PassThru

	$Timeouted = $Null # Reset any previously set timeout
	# Wait up to 180 seconds for normal termination
	$Proc | Wait-Process -Timeout $Timeout -ErrorAction SilentlyContinue -ErrorVariable Timeouted
	If ($Timeouted) {
		# Terminate the process
		$Proc | Kill
		Write-Output "Error: kill $Name uninstall exe"
		Return
	} ElseIf ($Proc.ExitCode -ne 0) {
		Write-Output "Error: $Name uninstall return code $($Proc.ExitCode)"
		Return
	}
}

# Remove other PuTTY
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf

		If ($($App.UninstallString) -match 'MsiExec.exe') {
			$Exe = 'MsiExec.exe'
			$Args = '/x "' + $KeyProduct + '" /qn /norestart'
			Write-Output "Remove MSI: $DisplayName / $DisplayVersion / $KeyProduct / $Exe $Args"
		} Else {
			$UninstallSplit = ($App.UninstallString -Split "exe")[0] -Replace '"', ''
			$Exe = $UninstallSplit + 'exe'
			$Args = '/SILENT'
			If (!(Test-Path -LiteralPath "$Exe")) { Return }
			Write-Output "Remove EXE: $DisplayName / $DisplayVersion / $($App.UninstallString) / $Exe $Args"
		}

		Run-Exec -FilePath "$Exe" -ArgumentList "$Args" -Name "$RefName"
	}

# Delete folder if still exists
ForEach ($SoftPath in "${Env:ProgramFiles}\PuTTY", "${Env:ProgramFiles(x86)}\PuTTY") {
	If (Test-Path -LiteralPath "$SoftPath\putty.exe") {
		Write-Output "Force Deleting $SoftPath\putty.exe..."
		Stop-Process -Name "putty" -Force
		Remove-Item -Path "$SoftPath\putty.exe" -Force -ErrorAction SilentlyContinue
	}
}

# View and Delete
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

		If (Test-Path $Key.PSPath) {
			Remove-Item -Path $Key.PSPath -Force -ErrorAction SilentlyContinue
			Write-Output "Registry key $Key deleted"
		}
	}
