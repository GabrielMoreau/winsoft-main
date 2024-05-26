
Write-Output "Begin Pre-Install"

# Pre-install script for add extension to MSEdge
# https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies#extensioninstallforcelist


If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist")) {
	# Create the key folder if not exists
	Write-Output "Warning: create register key ExtensionInstallForcelist"
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Force
}

# Ublock Origin
# https://microsoftedge.microsoft.com/addons/detail/ublock-origin/odfafepnkmbhccpbejgmiehpchacaeak
Write-Output "Info: set addon Ublock Origin"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "1" -Value 'odfafepnkmbhccpbejgmiehpchacaeak;https://edge.microsoft.com/extensionwebstorebase/v1/crx'

# Cookie AutoDelete
# https://microsoftedge.microsoft.com/addons/detail/cookie-autodelete/djkjpnciiommncecmdefpdllknjdmmmo
Write-Output "Info: set addon Cookie AutoDelete"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "2" -Value 'djkjpnciiommncecmdefpdllknjdmmmo;https://edge.microsoft.com/extensionwebstorebase/v1/crx'

# KeePassXC-Browser
# https://microsoftedge.microsoft.com/addons/detail/keepassxcbrowser/pdffhmdngciaglkoonimfcmckehcpafo
Write-Output "Info: set addon KeePassXC"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "3" -Value 'pdffhmdngciaglkoonimfcmckehcpafo;https://edge.microsoft.com/extensionwebstorebase/v1/crx'

# Decentraleyes
# https://microsoftedge.microsoft.com/addons/detail/decentraleyes/lmijmgnfconjockjeepmlmkkibfgjmla
#Write-Output "Info: set addon Decentraleyes"
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "4" -Value 'lmijmgnfconjockjeepmlmkkibfgjmla;https://edge.microsoft.com/extensionwebstorebase/v1/crx'

# ClearURLs
# https://microsoftedge.microsoft.com/addons/detail/clearurls/mdkdmaickkfdekbjdoojfalpbkgaddei
#Write-Output "Info: set addon ClearURLs"
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist" -Name "5" -Value 'mdkdmaickkfdekbjdoojfalpbkgaddei;https://edge.microsoft.com/extensionwebstorebase/v1/crx'
