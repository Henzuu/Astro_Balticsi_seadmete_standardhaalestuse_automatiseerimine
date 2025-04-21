Write-Host "Seadistame nüüd energia- ja toitevalikud..." 

# Ekraani välja lülitamine – 10 minutit (600 sekundit)
powercfg /change monitor-timeout-ac 10
powercfg /change monitor-timeout-dc 10

# Unele minek – 10 minutit
powercfg /change standby-timeout-ac 10
powercfg /change standby-timeout-dc 10

# Talveuni keelatud 
powercfg -h off

# Seame toiteplaaniks High Performance
powercfg /setactive SCHEME_MIN
Write-Host "Seadsin toiteplaaniks: High Performance"
