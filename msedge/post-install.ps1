
# Post-install for add extension
# https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies#extensioninstallforcelist

$RefVersion = '__VERSION__'

If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist")) {
	# Create the key folder
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Force | Out-Null
}

# Force install Ublock Origin on MSEdge
# https://microsoftedge.microsoft.com/addons/detail/ublock-origin/odfafepnkmbhccpbejgmiehpchacaeak
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "1" -Type String -Value '"odfafepnkmbhccpbejgmiehpchacaeak"'
