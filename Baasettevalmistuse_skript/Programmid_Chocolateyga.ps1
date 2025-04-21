# Kontrolli, kas Chocolatey on juba paigaldatud
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Paigaldan pakihaldur Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = `
    [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey pakihaldur on juba paigaldatud."
}

# Paigalda 7-Zip (MSI installeriga)
Write-Host "Paigaldan 7-Zipi..."
choco install 7zip.install -y

# Paigalda Adobe Acrobat Reader (MSI installeriga)
Write-Host "Paigaldan Adobe Readeri..."
choco install adobereader -y

# Paigalda Far Manager (MSI installeriga)
Write-Host "Paigaldan Far Manageri..."
choco install far -y