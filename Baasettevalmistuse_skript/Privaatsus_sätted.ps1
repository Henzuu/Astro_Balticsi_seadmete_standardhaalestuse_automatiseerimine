Write-Host "Seadistame privaatsussätted..." 

# Keela reklaami ID kasutamine
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0

# Keela keeleloendile ligipääs (language list for local content)
Set-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut" -Value 1

# Keela rakenduste käivitamise jälgimine Start/Search parandamiseks
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Value 0

# Keela soovitused ja reklaamisisu Seadete rakenduses
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353696Enabled" -Value 0

# Keela teavitused Seadete rakenduses
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SystemSettings\AccountNotifications" -Name "EnableAccountNotifications" -Value 0

# Tühista kasutaja nõusolek personaliseerimise privaatsustingimustega
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Value 0

# Keela käekirja ja teksti sisendi automaatne kogumine
Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Value 1

# Keela kontaktide kogumine andmetesse
Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Value 0

# Keela SafeSearch
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "SafeSearchMode" -Value 0

# Keela otsinguajalugu
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsDeviceSearchHistoryEnabled" -Value 0

# Keela Microsoft konto pilveotsing
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsMSACloudSearchEnabled" -Value 0

# Keela töö-/koolikonto pilveotsing
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsAADCloudSearchEnabled" -Value 0

# Keela rakenduste tulemuste kuvamine otsingus ("Let Search show app results")
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsGlobalWebSearchProviderToggleEnabled" -Value 0

# Keelab enamiku Windowsi rakenduste ligipääsu tundlikele õigustele 
$permissionsToKeep = @(
    "webcam",              # Camera
    "microphone",          # Microphone
    "appVoiceActivation"   # Voice activation
)

$allPermissions = @(
    "location",                    # Location
    "userNotificationListener",   # Notifications
    "userAccountInformation",     # Account info
    "contacts",                   # Contacts
    "calendar",                   # Calendar
    "phoneCall",                  # Phone calls
    "callHistory",                # Call history
    "email",                      # Email
    "tasks",                      # Tasks
    "sms",                        # Messaging
    "radios",                     # Radios
    "bluetoothSync",             # Other devices
    "appDiagnostics",            # App diagnostics
    "automaticFileDownloads",    # Automatic file downloads
    "documentsLibrary",          # Documents
    "downloadsFolder",           # Downloads folder
    "musicLibrary",              # Music library
    "picturesLibrary",           # Pictures
    "videosLibrary",             # Videos
    "broadFileSystemAccess",     # File system
    "graphicsCaptureWithoutBorder", # Screenshot borders
    "graphicsCaptureProgrammatic",  # Screenshots and screen recording
    "webcam",                    # Camera
    "microphone",                # Microphone
    "appVoiceActivation"         # Voice activation
)

foreach ($permission in $allPermissions) {
    if ($permissionsToKeep -notcontains $permission) {
        $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\$permission"
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        New-ItemProperty -Path $regPath -Name "Value" -PropertyType String -Value "Deny" -Force | Out-Null
    }
}

Write-Host "Privaatsuse sätted on keelatud va kaamera, mikrofon, voice activation." -ForegroundColor Cyan