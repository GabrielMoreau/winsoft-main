# Python - General-purpose dynamic programming language

Python is a free and open source high-level, general-purpose programming language.
Its design philosophy emphasizes code readability with the use of significant indentation. Python is dynamically type-checked and garbage-collected.
It supports multiple programming paradigms, including structured (particularly procedural), object-oriented and functional programming.

* Website : https://www.python.org/
* Wikipedia : https://en.wikipedia.org/wiki/Python_(programming_language)

* Download : https://www.python.org/downloads/windows/
* Silent uninstall : https://silentinstallhq.com/python-3-13-silent-uninstall-powershell/

## Remove old version

Script `Action-PythonKeepOnlyLast`.

```ps1
$UninstallKeys = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

# Get the last version
$LatestPython = Get-ItemProperty -Path $UninstallKeys -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName -match '^Python\s(\d+\.\d+\.\d+)' } |
    ForEach-Object {
        $_ | Add-Member -NotePropertyName ParsedVersion -NotePropertyValue ([Version]$Matches[1]) -PassThru
    } |
    Sort-Object ParsedVersion -Descending |
    Select-Object -First 1
$LatestVersion = $LatestPython.ParsedVersion.ToString()

# Uninstall first QuietUninstallString
Get-ItemProperty $UninstallKeys |
Where-Object {
    $_.DisplayName -match "^Python\s" -and
    $_.DisplayVersion -notlike "$LatestVersion*"
} |
ForEach-Object {
    Write-Host "Detect $($_.DisplayName)"
    If ($_.QuietUninstallString) {
        Write-Host " +QUIET cmd /c $_.QuietUninstallString"
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c",$_.QuietUninstallString -Wait
    }
}

# Secoind Uninstall round
Get-ItemProperty $UninstallKeys |
Where-Object {
    $_.DisplayName -match "^Python\s" -and
    $_.DisplayVersion -notlike "$LatestVersion*"
} |
ForEach-Object {
    Write-Host "Detect $($_.DisplayName)"
    If ($_.QuietUninstallString) {
        Write-Host " +QUIET-AGAIN cmd /c $_.QuietUninstallString"
        cmd /c $_.QuietUninstallString
    } ElseIf ($_.UninstallString) {
        If ($_.UninstallString -match "MsiExec.exe") {
            $Args = ($_.UninstallString -replace "MsiExec.exe /[IX]","/X") + " REBOOT=ReallySuppress /qn /norestart /L*v `"C:\Temp\Python-Uninstall.log`""
            Write-Host " +MSI $Args"
            Start-Process -FilePath "MsiExec.exe" -ArgumentList $Args -Wait
        } Else {
            Write-Host " +CMD $_.UninstallString"
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c",$_.UninstallString,"/quiet" -Wait
        }
    }
}
```


## Register Key

Example :

 | Hive | DisplayName | Publisher | DisplayVersion | KeyProduct | UninstallExe |
 |:---- |:----------- |:--------- |:-------------- |:---------- |:------------ |
 | HKLM | Python 3.14.3 Add to Path (64-bit)           | Python Software Foundation | 3.14.3150.0 | `{E4E7DA49-817E-4AE7-B2F0-E3FF45B0C588}` | `MsiExec.exe /I{E4E7DA49-817E-4AE7-B2F0-E3FF45B0C588}` |
 | HKLM | Python 3.14.3 Core Interpreter (64-bit)      | Python Software Foundation | 3.14.3150.0 | `{4B17826C-6E7E-4E62-BD21-DAFF56FB782C}` | `MsiExec.exe /I{4B17826C-6E7E-4E62-BD21-DAFF56FB782C}` |
 | HKLM | Python 3.14.3 Development Libraries (64-bit) | Python Software Foundation | 3.14.3150.0 | `{68887388-659F-4415-85CC-73371DBF8335}` | `MsiExec.exe /I{68887388-659F-4415-85CC-73371DBF8335}` |
 | HKLM | Python 3.14.3 Documentation (64-bit)         | Python Software Foundation | 3.14.3150.0 | `{5FADF399-D763-4C57-B169-178909B69BF6}` | `MsiExec.exe /I{5FADF399-D763-4C57-B169-178909B69BF6}` |
 | HKLM | Python 3.14.3 Executables (64-bit)           | Python Software Foundation | 3.14.3150.0 | `{B62B33AA-E1CF-411B-A28B-BB4311C38C61}` | `MsiExec.exe /I{B62B33AA-E1CF-411B-A28B-BB4311C38C61}` |
 | HKLM | Python 3.14.3 pip Bootstrap (64-bit)         | Python Software Foundation | 3.14.3150.0 | `{DF00E0A2-B8F5-4B60-84CD-8392F5FB9F62}` | `MsiExec.exe /I{DF00E0A2-B8F5-4B60-84CD-8392F5FB9F62}` |
 | HKLM | Python 3.14.3 Standard Library (64-bit)      | Python Software Foundation | 3.14.3150.0 | `{3C6BC713-D6F7-4021-9BEC-62F6B7D4BADF}` | `MsiExec.exe /I{3C6BC713-D6F7-4021-9BEC-62F6B7D4BADF}` |
 | HKLM | Python 3.14.3 Tcl/Tk Support (64-bit)        | Python Software Foundation | 3.14.3150.0 | `{5CAA53DC-458E-41BE-B7FB-7E943E472E6F}` | `MsiExec.exe /I{5CAA53DC-458E-41BE-B7FB-7E943E472E6F}` |
 | HKLM | Python Launcher                              | Python Software Foundation | 3.14.3150.0 | `{D1C302AD-2299-4673-987E-4BE725979548}` | `MsiExec.exe /X{D1C302AD-2299-4673-987E-4BE725979548}` |
 | HKU  | Python 3.14.3 (64-bit)                       | Python Software Foundation | 3.14.3150.0 | `{d91d5a08-1ddf-4529-909b-637a7fd19101}` | `"C:\WINDOWS\system32\config\systemprofile\AppData\Local\Package Cache\{d91d5a08-1ddf-4529-909b-637a7fd19101}\python-3.14.3-amd64.exe"  /uninstall` |
 | HKLM | Python 3.14.5 Add to Path (64-bit)           | Python Software Foundation | 3.14.5150.0 | `{F689BE51-4D7A-47E9-A4DF-1C42528856E7}` | `MsiExec.exe /I{F689BE51-4D7A-47E9-A4DF-1C42528856E7}` |
 | HKLM | Python 3.14.5 Core Interpreter (64-bit)      | Python Software Foundation | 3.14.5150.0 | `{E402961E-7539-41B4-ADA9-62143E6D32D7}` | `MsiExec.exe /I{E402961E-7539-41B4-ADA9-62143E6D32D7}` |
 | HKLM | Python 3.14.5 Development Libraries (64-bit) | Python Software Foundation | 3.14.5150.0 | `{59989632-5855-479A-A589-433911625C16}` | `MsiExec.exe /I{59989632-5855-479A-A589-433911625C16}` |
 | HKLM | Python 3.14.5 Documentation (64-bit)         | Python Software Foundation | 3.14.5150.0 | `{EDE01DCA-6375-4140-A590-B2FA5948D01D}` | `MsiExec.exe /I{EDE01DCA-6375-4140-A590-B2FA5948D01D}` |
 | HKLM | Python 3.14.5 Executables (64-bit)           | Python Software Foundation | 3.14.5150.0 | `{1B0251E9-CD20-49FC-AD22-70FCDBC2BAD7}` | `MsiExec.exe /I{1B0251E9-CD20-49FC-AD22-70FCDBC2BAD7}` |
 | HKLM | Python 3.14.5 pip Bootstrap (64-bit)         | Python Software Foundation | 3.14.5150.0 | `{7040E6D8-53FD-4FE0-A539-92C0B33E9A10}` | `MsiExec.exe /I{7040E6D8-53FD-4FE0-A539-92C0B33E9A10}` |
 | HKLM | Python 3.14.5 Standard Library (64-bit)      | Python Software Foundation | 3.14.5150.0 | `{A0B65FCB-97C6-47FD-984A-9EF9ECC1CE3B}` | `MsiExec.exe /I{A0B65FCB-97C6-47FD-984A-9EF9ECC1CE3B}` |
 | HKLM | Python 3.14.5 Tcl/Tk Support (64-bit)        | Python Software Foundation | 3.14.5150.0 | `{4B0FBDDD-D38E-48FF-A686-1A27792E66F9}` | `MsiExec.exe /I{4B0FBDDD-D38E-48FF-A686-1A27792E66F9}` |
 | HKLM | Python Launcher                              | Python Software Foundation | 3.14.5150.0 | `{A2CB2B82-276E-41CA-BD1D-FDA3F1FBD6BA}` | `MsiExec.exe /X{A2CB2B82-276E-41CA-BD1D-FDA3F1FBD6BA}` |
 | HKU  | Python 3.14.5 (64-bit)                       | Python Software Foundation | 3.14.5150.0 | `{2fc382fa-68a9-44f7-8851-98d7664255e6}` | `"C:\WINDOWS\system32\config\systemprofile\AppData\Local\Package Cache\{2fc382fa-68a9-44f7-8851-98d7664255e6}\python-3.14.5-amd64.exe"  /uninstall` |
