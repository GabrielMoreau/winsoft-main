# execution powershell mode RemoteSigned
# Set-ItemProperty -Path "hklm:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" -Name "ExecutionPolicy" -Value "RemoteSigned"

# Folder create
# If (!(Test-Path "${Env:ProgramData}\ImageJ" -PathType container)) {
# New-Item -ItemType directory -path "${Env:ProgramFiles}" -name "ImageJ"
# New-Item -ItemType directory -path "C:\Program Files\ImageJ" -name "print"
# }

$ImageJVersion = "__VERSION__"

If (Test-Path "${Env:ProgramData}\ImageJ\version.txt" -PathType Leaf) {
	$ImageJVersionOld = Get-Content -Path "${Env:ProgramData}\ImageJ\version.txt"
	# $ImageJVersionOld_number = [float]$ImageJVersionOld
}

# Install files and folders
ForEach ($File in 'install.bat', 'uninstall.bat', 'db.xml.gz', 'ImageJ-win64.exe', 'README.md', 'WELCOME.md') {
	Copy-Item -LiteralPath "$File" -Destination "${Env:ProgramData}\ImageJ" -Force
}
ForEach ($Folder in 'Contents', 'images', 'jars', 'java', 'lib', 'licenses', 'luts', 'macros', 'plugins', 'retro', 'scripts') {
	Copy-Item -LiteralPath "$Folder" -Destination "${Env:ProgramData}\ImageJ" -Recurse -Force
}

# ImageJ Script in Start Menu
$StartMenu = "${Env:ProgramData}\Microsoft\Windows\Start Menu\Programs"
If ((Test-Path -LiteralPath $StartMenu) -And (Test-Path -LiteralPath "${Env:ProgramData}\ImageJ\ImageJ-win64.exe")) {
	If (Test-Path -LiteralPath "$StartMenu\ImageJ.lnk") {
		Remove-Item "$StartMenu\ImageJ.lnk" -Force -ErrorAction SilentlyContinue
	}
	$WshShell = New-Object -ComObject WScript.Shell
	$Shortcut = $WshShell.CreateShortcut("$StartMenu\ImageJ.lnk")
	$Shortcut.TargetPath = "${Env:ProgramData}\ImageJ\ImageJ-win64.exe"
	$ShortCut.Arguments = ""
	$ShortCut.WorkingDirectory = "C:";
	$ShortCut.WindowStyle = 1;
	$ShortCut.Description = "ImageJ";
	$Shortcut.Save()
}

# Creation of the version file with the version number
New-Item -Path "${Env:ProgramData}\ImageJ\version.txt" -Type File -Force
$ImageJVersion | Set-Content -LiteralPath "${Env:ProgramData}\ImageJ\version.txt"
