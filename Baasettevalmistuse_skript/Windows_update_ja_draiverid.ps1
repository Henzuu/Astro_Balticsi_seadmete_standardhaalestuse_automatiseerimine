Write-Host "Vaatame üle, kas süsteem vajab uuendusi..."

# Paigaldame NuGet provideri, kui seda pole
Write-Host "Kontrollin NuGet providerit..."
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -ErrorAction SilentlyContinue

# Kontrollime ja impordime PSWindowsUpdate mooduli
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Host "PSWindowsUpdate moodulit ei leitud. Paigaldame..."
    Install-Module -Name PSWindowsUpdate -Scope CurrentUser -Force -AllowClobber
}

Import-Module PSWindowsUpdate

# Kuvame saadaolevad uuendused (sh draiverid)
Write-Host "Saadaolevad Windowsi uuendused ja draiverid:"
Get-WindowsUpdate -MicrosoftUpdate

# Paigaldame kõik uuendused ja draiverid (ilma automaatse restartita)
Write-Host "Paigaldan uuendused ja draiverid..."
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot -Verbose