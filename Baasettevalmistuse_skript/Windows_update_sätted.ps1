Write-Host "Seadistame Windows Update teenuse sätted..."

# Lülitame sisse "Receive updates for other Microsoft products" ja "Notify if restart is required"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "AllowMUUpdateService" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "RestartNotificationsAllowed2" -Value 1

# Taaskäivitame Windows Update teenuse
Restart-Service wuauserv -Force

Write-Host "Windows Update sätted on muudetud: Microsofti toodete uuendused ja taaskäivitusteated on lubatud." -ForegroundColor Green

# Loome Delivery Optimization registritee, kui see ei eksisteeri
if (-not (Test-Path "HKLM:\Software\Policies\Microsoft\Windows\DeliveryOptimization")) {
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\DeliveryOptimization" -Force | Out-Null
}

# Keelame allalaadimised teistelt arvutitelt
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DeliveryOptimization" -Name "DODownloadMode" -Value 0

Write-Host "Seade 'Allow downloads from other PCs' on keelatud." -ForegroundColor Green
Write-Host "Windows Update sätted seadistatud. Valmis!" -ForegroundColor Green