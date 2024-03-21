
# Check WithSecure Hotfixes

$HotfixList = @('WSBS1600-HF01','WSBS1600-HF03','WSBS1600-HF04','WSBS1600-HF05','WSBS1600-HF06')

$TotalHotfix = $HotfixList.Count
$HotfixesInstalled = 0
@(Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\F-Secure\NS\default\BusinessSuite\Hotfixes") |
	ForEach {
		$RegisterField = $_
		ForEach ($HotfixMatch in $HotfixList) {
			If ($RegisterField -match $HotfixMatch) {
				$HotfixesInstalled++
				Write-Output "Info: hotfixes $HotfixMatch is installed"
			}
		}
	}

If ($HotfixesInstalled -Eq $TotalHotfix) {
	Write-Output  "Ok: $HotfixesInstalled hotfixes installed"
	Exit 0
} Else {
	$ErrCode = ($HotfixesInstalled + 100)
	Write-Output  "Warning: only $HotfixesInstalled on $TotalHotfix hotfixes installed"
	Exit $ErrCode
}

Return

# Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\F-Secure\NS\default\BusinessSuite\Hotfixes" | Out-GridView
#
# {"applied":1708596792,"description":"This hotfix fixes default firewall rules for Policy Manager (CSEP-7338).","id":"WSBS1600-HF01","product":"WithSecure™ Client Security Premium","version":"16.0.8376.0"}
# {"applied":1708596803,"description":"This hotfix activates SWUP for CS/SS Premium (CSEP-7384).","id":"WSBS1600-HF03","product":"WithSecure™ Client Security Premium","version":"16.0.8376.0"}
# {"applied":1708596810,"description":"This hotfix fixes issue with product updates installations after upgrade from 14/15 versions (CSEP-7372).","id":"WSBS1600-HF04","product":"WithSecure™ Client Security Premium","version":"16.0.8376.0"}
# {"applied":1708596818,"description":"This hotfix fixes issue with channel updates after upgrade from the 15.XX version (CSEP-7357).","id":"WSBS1600-HF05","product":"WithSecure™ Client Security Premium","version":"16.0.8376.0"}
