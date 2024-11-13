
# Check WithSecure Hotfixes

# WSBS1600-HF       -> HKLM:\SOFTWARE\WOW6432Node\F-Secure\NS\default\BusinessSuite\Hotfixes
# WithSecure Hotfix -> HKLM:\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules

# Version 16.00
# $HotfixList = @{'WSBS1600-HF01' = 1; 'WSBS1600-HF03' = 4; 'WSBS1600-HF04' = 8; 'WSBS1600-HF05' = 16; 'WSBS1600-HF06' = 32}
# $FwHfList   = @{'WithSecure Hotfix2' = 2}

# Version 16.01
$HotfixList = @{'WSBS1601-HF01' = 1}
$FwHfList   = @{}

$WSVersion = '16.01'

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

# Verify if WithSecure is installed
$IsInstalled = $False
$RefName = 'WithSecure. Client Security'
@(Get-ChildItem -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Get-ChildItem -Recurse "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
	ForEach {
		$Key = $_
		$App = (Get-ItemProperty -Path $Key.PSPath)
		$DisplayName  = $App.DisplayName
		If ($DisplayName -match $RefName) {
			$DisplayVersion = $App.DisplayVersion
			$UninstallString = $App.UninstallString
			$IsInstalled = $True
			Write-Output "Info: $DisplayName / $DisplayVersion / $UninstallString"
			If ((ToVersion($DisplayVersion)) -lt (ToVersion($WSVersion))) {
				Write-Output "Warning: WithSecure installed version $DisplayVersion is lower than the reference one $WSVersion"
			}
			Return
		}
	}

# Exit now if not installed
If ($IsInstalled -Eq $False) {
	Write-Output  "Error: WithSecure is not installed"
	Exit 1024
}

# Total count values
$HotfixesSum = 0
ForEach ($CurrentBit in ($HotfixList.Values + $FwHfList.Values)) {
	$HotfixesSum += $CurrentBit
}
# Verify classic Hotfix
$TotalHotfix = $HotfixList.Count + $FwHfList.Count
$HotfixesInstalled = 0
$HotfixesPartialSum = 0
@(Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\F-Secure\NS\default\BusinessSuite\Hotfixes") |
	ForEach {
		$RegisterField = $_
		#Write-Output "Debug: $RegisterField"
		ForEach ($HotfixMatch in $HotfixList.Keys) {
			If ($RegisterField -match $HotfixMatch) {
				$HotfixesInstalled++
				$HotfixesPartialSum += $HotfixList["$HotfixMatch"]
				Write-Output "Info: hotfixes $HotfixMatch is installed"
			}
		}
	}

# Verify firewall Hotfix
Get-NetFirewallRule | ForEach {
	$FwRuleDescription = $_.DisplayName
	#Write-Output "Debug: $FwRuleDescription"
	ForEach ($HotfixMatch in $FwHfList.Keys) {
		If ($FwRuleDescription -match "^($HotfixMatch):") {
			$HotfixesInstalled++
			$HotfixesPartialSum += $FwHfList["$HotfixMatch"]
			Write-Output "Info: firewall hotfixes $HotfixMatch is installed"
		}
	}
}

If ($HotfixesPartialSum -Eq $HotfixesSum) {
	Write-Output  "Ok: $HotfixesInstalled hotfixes installed"
	Exit 0
} Else {
	$ErrCode = ($HotfixesSum -Bxor $HotfixesPartialSum)
	Write-Output  "Warning: only $HotfixesInstalled on $TotalHotfix hotfixes installed, error code $ErrCode"
	Exit $ErrCode
}

Return


# Info: WithSecure™ Client Security Premium / 16.00 / C:\Program Files (x86)\F-Secure\Client Security\fs_uninstall_32.exe

# Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\F-Secure\NS\default\BusinessSuite\Hotfixes" | Out-GridView
#
# {"applied":1708596792,"description":"This hotfix fixes default firewall rules for Policy Manager (CSEP-7338).","id":"WSBS1600-HF01","product":"WithSecure™ Client Security Premium","version":"16.0.8376.0"}
# {"applied":1708596803,"description":"This hotfix activates SWUP for CS/SS Premium (CSEP-7384).","id":"WSBS1600-HF03","product":"WithSecure™ Client Security Premium","version":"16.0.8376.0"}
# {"applied":1708596810,"description":"This hotfix fixes issue with product updates installations after upgrade from 14/15 versions (CSEP-7372).","id":"WSBS1600-HF04","product":"WithSecure™ Client Security Premium","version":"16.0.8376.0"}
# {"applied":1708596818,"description":"This hotfix fixes issue with channel updates after upgrade from the 15.XX version (CSEP-7357).","id":"WSBS1600-HF05","product":"WithSecure™ Client Security Premium","version":"16.0.8376.0"}

# Name                          : {E61BEFA0-335A-40B4-BFBE-41BB02012B5C}
# DisplayName                   : WithSecure Hotfix2: Allow outbound TCP traffic
# Description                   : WithSecure Hotfix2: Allow outbound TCP traffic
# DisplayGroup                  : WithSecure Firewall
# Group                         : WithSecure Firewall
