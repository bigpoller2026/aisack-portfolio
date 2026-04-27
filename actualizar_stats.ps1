# Script para actualizar estadísticas del portafolio de AISACK TH
$htmlFile = "index.html"

if (-Not (Test-Path $htmlFile)) {
    Write-Host "Error: No se encontró el archivo index.html" -ForegroundColor Red
    exit
}

$html = Get-Content $htmlFile -Raw

Write-Host "--- Actualizador de Estadísticas ---" -ForegroundColor Yellow
$ig = Read-Host "1. Ingresa el nuevo número de seguidores en Instagram (solo números)"
$sp = Read-Host "2. Ingresa el nuevo número de reproducciones en Spotify (solo números)"

if ($ig -ne "") {
    $html = $html -replace '(<div id="ig-count" [^>]*data-target=")\d+(")', "${1}$ig${2}"
}
if ($sp -ne "") {
    $html = $html -replace '(<div id="sp-count" [^>]*data-target=")\d+(")', "${1}$sp${2}"
}

$html | Set-Content $htmlFile -NoNewline

Write-Host "`n[OK] index.html actualizado localmente." -ForegroundColor Green

$confirm = Read-Host "¿Quieres subir estos cambios a GitHub ahora mismo? (S/N)"
if ($confirm -eq "S" -or $confirm -eq "s") {
    Write-Host "Subiendo a GitHub..." -ForegroundColor Cyan
    git add $htmlFile
    git commit -m "Actualización manual de estadísticas (IG: $ig, SP: $sp)"
    git push origin main
    Write-Host "[OK] Cambios subidos a GitHub." -ForegroundColor Green
} else {
    Write-Host "Cambios guardados localmente pero NO subidos." -ForegroundColor Yellow
}

Write-Host "`nProceso finalizado. Presiona cualquier tecla para salir..."
$null = [Console]::ReadKey($true)
