Write-Host "Lubame Telneti..."

# Lubab Telneti kliendi ilma taaskäivitust ootamata
dism /online /Enable-Feature /FeatureName:TelnetClient /NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName TelnetClient -NoRestart

Write-Host "Telnet lubatud." -ForegroundColor Green
