# Debloat skripti paigaldamine ja käivitamine
$debloatZipUrl = "https://github.com/teeotsa/windows-11-debloat/archive/refs/heads/main.zip"
$debloatZipPath = "$env:USERPROFILE\windows-11-debloat.zip"
$debloatFolderPath = "$env:USERPROFILE\windows-11-debloat"
$debloatExtractPath = "$debloatFolderPath\windows-11-debloat-main"
$launchBatPath = "$debloatExtractPath\Launch.bat"

# Kontrollime, kas debloat kaust ja Launch.bat fail eksisteerivad
if (-not (Test-Path $launchBatPath)) {
    Write-Host "Laen alla ja pakin lahti debloateri skripti..."

    # Kui debloat kaust on juba olemas, siis eemaldame selle enne uuesti lahtipakkimist
    if (Test-Path $debloatExtractPath) {
        Write-Host "Eemaldan vana debloateri kausta..."
        Remove-Item -Recurse -Force $debloatExtractPath
    }

    # Lae alla ZIP-fail
    Invoke-WebRequest -Uri $debloatZipUrl -OutFile $debloatZipPath

    # Paki ZIP lahti
    Write-Host "Pakkin ZIP-faili lahti..."
    Expand-Archive -Path $debloatZipPath -DestinationPath $debloatFolderPath -Force

    # Eemaldame ZIP faili pärast lahtipakkimist
    Remove-Item $debloatZipPath
}

# Igal juhul käivitame Launch.bat
if (Test-Path $launchBatPath) {
    Write-Host "Käivitame Launch.bat..."
    Start-Process -FilePath $launchBatPath -NoNewWindow -Wait
} else {
    Write-Host "Faili Launch.bat ei leitud isegi pärast lahtipakkimist!"
}