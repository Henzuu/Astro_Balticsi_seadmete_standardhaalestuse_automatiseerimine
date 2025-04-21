Write-Host "Keelame automaatse vaikeprinteri haldamise..."

# Windows vaikeprinter halduse välja lülitamine
$RegPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows"

# Seadistuse LÜLITAMINE VÄLJA
Set-ItemProperty -Path $RegPath -Name "LegacyDefaultPrinterMode" -Value 1

# Teavitame kasutajat
Write-Host "Windows EI halda enam vaikeprinterit automaatselt." -ForegroundColor Green