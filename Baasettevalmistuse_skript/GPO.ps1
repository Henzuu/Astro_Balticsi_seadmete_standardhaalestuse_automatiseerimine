Write-Host "Rakendame rühmapoliitika seaded..."

# Seadista ajutised asukohad
$tempDir = "$env:TEMP\lgpo_temp"
New-Item -Path $tempDir -ItemType Directory -Force | Out-Null

# Lae alla ja paki lahti LGPO tööriist
Invoke-WebRequest "https://download.microsoft.com/download/8/5/c/85c25433-a1b0-4ffa-9429-7e023e7da8d8/LGPO.zip" -OutFile "$tempDir\LGPO.zip"
Expand-Archive "$tempDir\LGPO.zip" -DestinationPath $tempDir -Force
Remove-Item "$tempDir\LGPO.zip" -Force

# Lae alla ja paki lahti konfiguratsioon
Invoke-WebRequest "https://cloud.noom.ee/index.php/s/CX52SDdw556deFG/download" -OutFile "$tempDir\config.zip"
Expand-Archive "$tempDir\config.zip" -DestinationPath "$tempDir\config" -Force
Remove-Item "$tempDir\config.zip" -Force

# Leia GPO_must.zip ja paki lahti
$gpoZip = Get-ChildItem "$tempDir\config" -Filter "GPO_must.zip" -Recurse | Select-Object -First 1
Expand-Archive $gpoZip.FullName -DestinationPath "$tempDir\gpo" -Force

# Rakenda GPO seaded
$lgpo = Get-ChildItem $tempDir -Filter LGPO.exe -Recurse | Select-Object -First 1
Start-Process $lgpo.FullName -ArgumentList "/g `"$tempDir\gpo`"" -Wait
gpupdate /force

Write-Host "Rühmapoliitika loodud! Sätted rakenduvad peale taaskäivitust."

# Korista ajutised failid
Write-Host "Koristan ajutised failid..."
Remove-Item -Path $tempDir -Recurse -Force