$root = Split-Path $PSScriptRoot -Parent
$modInfo = Get-Content (Join-Path $root "modinfo.json") | ConvertFrom-Json
$version = $modInfo.version
$modName = "FotSAButcheringCompat"

$releasesFolder = Join-Path $root "releases"
if (!(Test-Path $releasesFolder)) {
    New-Item -ItemType Directory -Path $releasesFolder | Out-Null
}

$outputZip = Join-Path $releasesFolder "$($modName)_$version.zip"

if (Test-Path $outputZip) {
    Remove-Item $outputZip
}

Compress-Archive -Path (Join-Path $root "assets"), (Join-Path $root "modinfo.json") -DestinationPath $outputZip
Write-Host "Le fichier $outputZip a été créé avec succès."

$modsFolder = Join-Path $env:APPDATA "VintagestoryData\Mods"

if (Test-Path $modsFolder) {
    # Supprimer les anciennes versions de ce mod dans le dossier Mods
    Get-ChildItem -Path $modsFolder -Filter "$($modName)_*.zip" | Remove-Item -Force

    Copy-Item -Path $outputZip -Destination $modsFolder -Force
    Write-Host "Le fichier a été copié dans $modsFolder et les anciennes versions ont été supprimées."
} else {
    Write-Warning "Le dossier des mods $modsFolder n'existe pas."
}
