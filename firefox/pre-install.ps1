
Write-Output "Begin Pre-Install"

# Remove Policies by register key, only by policies.json
# https://support.mozilla.org/en-US/questions/1302600

If (Test-Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox\') {
	Write-Output "Remove: Register Firefox Policies"
	Remove-Item -Path 'HKLM:\SOFTWARE\Policies\Mozilla' -Force -Recurse -ErrorAction SilentlyContinue
}
