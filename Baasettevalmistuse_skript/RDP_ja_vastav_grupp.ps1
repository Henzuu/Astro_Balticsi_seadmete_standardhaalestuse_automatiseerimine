Write-Host "Konfigureerin Remote Desktopi ligipääsu..."

# Luba Remote Desktop süsteemisätetes
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0

# Luba RDP läbi Windowsi tulemüüri
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Veendu, et Remote Desktopi teenus on lubatud ja käivitatud
Set-Service -Name TermService -StartupType Automatic
Start-Service -Name TermService

# Lisa praegune kasutaja Remote Desktop Users ja Users gruppidesse
$currentUser = "$env:USERDOMAIN\$env:USERNAME"

# Lisa Remote Desktop Users gruppi
Add-LocalGroupMember -Group "Remote Desktop Users" -Member $currentUser -ErrorAction SilentlyContinue

# Lisa Users gruppi (tavakasutajad)
Add-LocalGroupMember -Group "Users" -Member $currentUser -ErrorAction SilentlyContinue

Write-Host "Remote Desktop on lubatud ja konfigureeritud. Kasutaja '$currentUser' lisatud gruppidesse: Remote Desktop Users, Users."