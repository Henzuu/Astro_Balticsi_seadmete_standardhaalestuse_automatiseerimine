Write-Host "Seadistame tegumiriba: eemaldame mittevajalikud ikoonid ja joondame vasakule..."

# Ühine registritee tegumiriba seadistustele
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$regPathSearch = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"

# Keelame Task View ja Widgets ikoonid tegumireal
Set-ItemProperty -Path $regPath -Name "ShowTaskViewButton" -Value 0
Set-ItemProperty -Path $regPath -Name "TaskbarDa" -Value 0

# Keelame otsingukasti tegumiribal
Set-ItemProperty -Path $regPathSearch -Name "SearchboxTaskbarMode" -Type DWord -Value 0

# Määrame tegumiriba joondatuse vasakule
Set-ItemProperty -Path $regPath -Name "TaskbarAl" -Value 0

# Taaskäivitame Explorer.exe, et muudatused jõustuksid
Stop-Process -Name explorer -Force
Start-Process explorer
Stop-Process -Name explorer -Force

Write-Host "Task View, Widgets ja otsingukast on eemaldatud ning tegumiriba on vasakul!" -ForegroundColor Green