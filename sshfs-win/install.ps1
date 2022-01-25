
# Copy the script on the system
Copy-Item -Path "sshfs-win-connect.ps1" -Destination "$Env:ProgramFiles\SSHFS-Win\sshfs-win-connect.ps1" -Force

$StartMenu = "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs"

# Add an entry in the Start Menu
If ((Test-Path -LiteralPath $StartMenu) -And (Test-Path -LiteralPath "$Env:ProgramFiles\SSHFS-Win\sshfs-win-connect.ps1")) {
	If (Test-Path -LiteralPath "$StartMenu\SSHFS Win Connect.lnk") {
		Remove-Item "$StartMenu\SSHFS Win Connect.lnk" -Force -ErrorAction SilentlyContinue
	}
	$WshShell = New-Object -ComObject WScript.Shell
	$Shortcut = $WshShell.CreateShortcut("$StartMenu\SSHFS Win Connect.lnk")
	$Shortcut.TargetPath = "powershell.exe"
	$ShortCut.Arguments = "-ExecutionPolicy Bypass -File `"$Env:ProgramFiles\SSHFS-Win\sshfs-win-connect.ps1`""
	$ShortCut.WorkingDirectory = " `"$Env:ProgramFiles%\SSHFS-Win";
	$ShortCut.WindowStyle = 1;
	$ShortCut.IconLocation = "$Env:ProgramFiles%\SSHFS-Win\sshfs-win.ico";
	$ShortCut.Description = "SSHFS Windows Connection";
	$Shortcut.Save()
}
