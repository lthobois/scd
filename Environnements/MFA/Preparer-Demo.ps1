[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
Get-Command docker -ErrorAction Stop | Out-Null
& docker info --format '{{.ServerVersion}}'
if ($LASTEXITCODE -ne 0) { throw 'Le moteur Docker doit être démarré.' }
$envFile = Join-Path $PSScriptRoot '.env'
if (-not (Test-Path -LiteralPath $envFile)) {
    $demoAdminSecret = ([guid]::NewGuid().ToString('N') + [guid]::NewGuid().ToString('N'))
    Set-Content -LiteralPath $envFile -Value "SCD_MFA_ADMIN_PASSWORD=$demoAdminSecret" -Encoding utf8
}
Push-Location $PSScriptRoot
try {
    & docker compose config --quiet
    if ($LASTEXITCODE -ne 0) { throw 'Configuration Compose invalide.' }
    & docker compose pull
    if ($LASTEXITCODE -ne 0) { throw 'Téléchargement de Keycloak impossible ; préparer le repli documentaire.' }
    & docker compose up -d
    if ($LASTEXITCODE -ne 0) { throw 'Démarrage Keycloak impossible.' }
    Write-Host 'Attendre la fin du démarrage (docker compose logs), puis ouvrir http://localhost:18080/admin/'
    Write-Host 'Administration : scd-admin ; mot de passe uniquement dans le fichier local .env.'
    Write-Host 'Compte fictif : prest-01 ; mot de passe pédagogique dans novalys-realm.json.'
}
finally { Pop-Location }
