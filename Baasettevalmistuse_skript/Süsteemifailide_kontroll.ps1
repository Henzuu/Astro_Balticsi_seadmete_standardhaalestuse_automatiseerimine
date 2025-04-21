# Süsteemifailide kontroll (sfc /scannow)
Write-Host "Algab süsteemi failide kontrollimine... (sfc /scannow)" -ForegroundColor Cyan
sfc /scannow
Write-Host "Süsteemi faili kontrollimine lõppenud!" -ForegroundColor Green