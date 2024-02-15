
Write-Output "Begin Pre-Install"

Import-Certificate -FilePath 'Adafruit.cer' -CertStoreLocation Cert:\LocalMachine\TrustedPublisher
Import-Certificate -FilePath 'Arduino.cer'  -CertStoreLocation Cert:\LocalMachine\TrustedPublisher
