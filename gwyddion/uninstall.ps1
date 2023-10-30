
$RefName = 'Gwyddion'

# Remove old Rocket.Chat
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If (!($DisplayName -match $RefName)) { Return }

		If (!($App.UninstallString -match 'uninstall.exe')) { Return } # only uninstall exe

		$DisplayVersion = $App.DisplayVersion
		$KeyProduct = $Key | Split-Path -Leaf

		$Exe = $App.UninstallString
		$Args = '/S'
		Write-Output "Remove: $DisplayName / $DisplayVersion / $KeyProduct / $Exe $Args"

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

# HKLM	Gwyddion	Gwyddion developers	2.64.win64	Gwyddion	C:\Program Files\Gwyddion\uninstall.exe	
