
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Output ("`nBegin Installer [$TimeStamp]`n" + "=" * 40 + "`n")

########################################################################

# Get Config from file
Function GetConfig {
	Param (
		[Parameter(Mandatory = $True)] [string]$FilePath
	)

	Return Get-Content "$FilePath" | Where-Object { $_ -Match '=' } | ForEach-Object { $_ -Replace "#.*", "" } | ForEach-Object { $_ -Replace "\\", "\\" } | ConvertFrom-StringData
}

# Transform string to a version object
Function ToVersion {
	Param (
		[Parameter(Mandatory = $true)] [string]$Version
	)

	$Version = $Version -Replace '[^\d\.].*$', ''
	$Version = "$Version.0.0.0"
	$Version = $Version -Replace '\.+',     '.'
	$Version = $Version -Replace '\.0+',    '.0'
	$Version = $Version -Replace '\.0(\d)', '.$1'
	$Version = $Version.Split('.')[0,1,2,3] -Join '.'
	Return [version]$Version
}

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

########################################################################

$UninstallKeys = @(
	'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
	'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
)

########################################################################

# Get Config: Version
$Config = GetConfig -FilePath 'winsoft-config.ini'
$RefVersion = ToVersion $Config.Version
$RefName = $Config.RegexSearch
Write-Output "Config:`n * Version: $RefVersion`n * RegexSearch: $RefName"

########################################################################
# Put your specific code here

$ReturnCode = 0

If (Test-Path "${Env:ProgramData}\ImageJ\version.txt" -PathType Leaf) {
	$RefVersionOld = Get-Content -Path "${Env:ProgramData}\ImageJ\version.txt"
	# $RefVersionOld_number = [float]$RefVersionOld
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
$RefVersion | Set-Content -LiteralPath "${Env:ProgramData}\ImageJ\version.txt"

########################################################################

Write-Output "ReturnCode: $ReturnCode"
Exit $ReturnCode
