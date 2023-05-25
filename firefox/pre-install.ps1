
# Remove Policies by register key, only by policies.json
# https://support.mozilla.org/en-US/questions/1302600

If (Test-Path 'HKLM:Software\Policies\Mozilla\Firefox\') {
	Remove-Item -Path 'HKLM:Software\Policies\Mozilla' -Force -Recurse -ErrorAction SilentlyContinue
}
