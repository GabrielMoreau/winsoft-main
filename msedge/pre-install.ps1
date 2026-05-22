
$TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Output ("Begin Pre-Install [$TimeStamp]`n" + "=" * 39 + "`n")

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


# Pre-install script for add extension to MSEdge
# https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies#extensioninstallforcelist


If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist")) {
	# Create the key folder if not exists
	Write-Output "Warning: create register key ExtensionInstallForcelist"
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Force
}

$Count = 0

# Ublock Origin
# https://microsoftedge.microsoft.com/addons/detail/ublock-origin/odfafepnkmbhccpbejgmiehpchacaeak
$Count++
Write-Output "Info: set addon Ublock Origin"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "$Count" -Value 'odfafepnkmbhccpbejgmiehpchacaeak;https://edge.microsoft.com/extensionwebstorebase/v1/crx'

# Cookie AutoDelete
# https://microsoftedge.microsoft.com/addons/detail/cookie-autodelete/djkjpnciiommncecmdefpdllknjdmmmo
$Count++
Write-Output "Info: set addon Cookie AutoDelete"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "$Count" -Value 'djkjpnciiommncecmdefpdllknjdmmmo;https://edge.microsoft.com/extensionwebstorebase/v1/crx'

# KeePassXC-Browser
# https://microsoftedge.microsoft.com/addons/detail/keepassxcbrowser/pdffhmdngciaglkoonimfcmckehcpafo
$Count++
Write-Output "Info: set addon KeePassXC"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "$Count" -Value 'pdffhmdngciaglkoonimfcmckehcpafo;https://edge.microsoft.com/extensionwebstorebase/v1/crx'

# Decentraleyes
# https://microsoftedge.microsoft.com/addons/detail/decentraleyes/lmijmgnfconjockjeepmlmkkibfgjmla
#$Count++
#Write-Output "Info: set addon Decentraleyes"
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "$Count" -Value 'lmijmgnfconjockjeepmlmkkibfgjmla;https://edge.microsoft.com/extensionwebstorebase/v1/crx'

# ClearURLs
# https://microsoftedge.microsoft.com/addons/detail/clearurls/mdkdmaickkfdekbjdoojfalpbkgaddei
#$Count++
#Write-Output "Info: set addon ClearURLs"
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "$Count" -Value 'mdkdmaickkfdekbjdoojfalpbkgaddei;https://edge.microsoft.com/extensionwebstorebase/v1/crx'

# Country Flag +
# https://microsoftedge.microsoft.com/addons/detail/country-flag-/pjmpopjdnmhbggenigchmnkefkgjjohe
$Count++
Write-Output "Info: set addon Country Flag +"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "$Count" -Value 'pjmpopjdnmhbggenigchmnkefkgjjohe;https://edge.microsoft.com/extensionwebstorebase/v1/crx'

# Click and Read CNRS
# https://microsoftedge.microsoft.com/addons/detail/click-and-read-cnrs/edcglkjkkcbcboogiiigphjodndbogab
$Count++
Write-Output "Info: set addon Click and Read CNRS"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "$Count" -Value 'edcglkjkkcbcboogiiigphjodndbogab;https://edge.microsoft.com/extensionwebstorebase/v1/crx'


########################################################################

# View
$ReturnCode = 0
ForEach ($Key in Get-ChildItem -Recurse $UninstallKeys) {
	$App = Get-ItemProperty -Path $Key.PSPath
	If ($App.DisplayName -notmatch $RefName) { Continue }

	$DisplayVersion = ToVersion $App.DisplayVersion
	$KeyProduct     = $Key.PSChildName
	Write-Output "Installed: $($App.DisplayName) / $DisplayVersion / $KeyProduct / $($App.UninstallString)"
}
Write-Output "ReturnCode: $ReturnCode"
Exit $ReturnCode
