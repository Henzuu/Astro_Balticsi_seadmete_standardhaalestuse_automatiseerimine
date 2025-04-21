Write-Output "Keelan Power Managementi ainult 'Network adapters' seadmetel..."

# Leia kõik võrgukaardid, olenemata olekust
$netAdapters = Get-CimInstance Win32_NetworkAdapter
$powerMgmt = Get-CimInstance MSPower_DeviceEnable -Namespace root\wmi

foreach ($adapter in $netAdapters) {
    # Kontrolli, et PNPDeviceID ei oleks null
    if ($adapter.PNPDeviceID -and -not $adapter.Name.StartsWith("WAN Miniport")) {
        $pnpID = $adapter.PNPDeviceID.ToUpper()
        $match = $powerMgmt | Where-Object { $_.InstanceName.ToUpper().StartsWith($pnpID) }
        
        foreach ($p in $match) {
            Write-Output "Keelan Power Managementi seadmel: $($adapter.Name)"
            Set-CimInstance -InputObject $p -Property @{ Enable = $false }
        }
    }
}

Write-Output "Valmis – Power Management keelatud füüsilistel võrguadapteritel."