Write-Host "Keelame IPv6 ja kontrollime, kas File and Printer Sharing tuleks jätta alles..."

# Kontrollime, kas jagatud printereid on
$onJagatudPrintereid = (Get-Printer | Where-Object {$_.Shared}).Count -gt 0

# Kontrollime, kas on jagatud kaustu (vältides süsteemijagamisi nagu ADMIN$)
$onJagatudKaustu = (Get-WmiObject -Class Win32_Share | Where-Object {
    $_.Name -ne "ADMIN$" -and $_.Name -ne "IPC$"
}).Count -gt 0

# Kui on printereid või kaustu jagatud, siis jätame File Sharingu alles
$onMidagiJagatud = $onJagatudPrintereid -or $onJagatudKaustu

Write-Output "Keelan IPv6 kõigil võrgukaartidel"
if ($onMidagiJagatud) {
    Write-Output "Leiti jagatud printereid või kaustu – File and Printer Sharing jääb lubatuks"
} else {
    Write-Output "Ei leitud jagamisi – File and Printer Sharing keelatakse"
}

# Käime kõik adapterid läbi ja seadistame
Get-NetAdapter | ForEach-Object {
    Disable-NetAdapterBinding -Name $_.Name -ComponentID ms_tcpip6 -Confirm:$false
    if (-not $onMidagiJagatud) {
        Disable-NetAdapterBinding -Name $_.Name -ComponentID ms_server -Confirm:$false
    }
}

Write-Output "Valmis! IPv6 on keelatud."
if (-not $onMidagiJagatud) {
    Write-Output "File and Printer Sharing on samuti keelatud."
}
