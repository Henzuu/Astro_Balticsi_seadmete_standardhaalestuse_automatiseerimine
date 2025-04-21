Write-Host "Alustan taustapildi allalaadimist ja seadistamist..."

# Lae alla ja määra uus taustapilt

$zipUrl = "https://cloud.noom.ee/index.php/s/CX52SDdw556deFG/download"
$tempDir = "$env:TEMP\taustapilt_temp"
$zipFile = "$tempDir\pilt.zip"
$wallpaperDest = "$env:USERPROFILE\fhd-screens-3.jpg"

# Loo ajutine kaust
New-Item -Path $tempDir -ItemType Directory -Force | Out-Null

# Lae ZIP-fail alla
Invoke-WebRequest $zipUrl -OutFile $zipFile

# Paki lahti
Expand-Archive $zipFile -DestinationPath $tempDir -Force

# Leia pilt ja tõsta see õigesse kohta
$pilt = Get-ChildItem $tempDir -Recurse -Filter "fhd-screens-3.jpg" | Select-Object -First 1
Copy-Item $pilt.FullName -Destination $wallpaperDest -Force

# Sea taustapilt
Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $wallpaperDest
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters ,1 ,True

# Korista järelt
Remove-Item $tempDir -Recurse -Force