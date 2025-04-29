#!/usr/bin/pwsh

Param (
	[Parameter(Mandatory = $true)][string]$Path
)

# Vérifier que le fichier existe
if (!(Test-Path -Path $Path)) {
	Write-Error "Le fichier '$Path' n'existe pas."
	Exit 1
}

# Analyse du fichier
$Errors = $Null
$Tokens = $Null

$AST = [System.Management.Automation.Language.Parser]::ParseFile(
	(Resolve-Path -Path $Path).Path,
	[ref]$Tokens,
	[ref]$Errors
)

If ($Errors.Count -eq 0) {
	Write-Host "✅ Syntaxe correcte pour '$Path'." -ForegroundColor Green
	Exit 0
} Else {
	Write-Host "❌ Erreurs de syntaxe trouvées dans '$Path' :" -ForegroundColor Red
	ForEach ($Error in $Errors) {
		$Position = $Error.Extent.StartLineNumber
		$Column   = $Error.Extent.StartColumnNumber
		$Message  = $Error.Message
		Write-Host "Ligne $Position, Colonne $Column : $Message" -ForegroundColor Yellow
	}
	Exit 2
}
