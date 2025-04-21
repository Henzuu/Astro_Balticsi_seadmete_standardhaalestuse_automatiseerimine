Write-Host "Seadistame keele- ja piirkonnasätted Eesti jaoks..."

# Määra ajavööndiks Eesti
Set-TimeZone -Id "FLE Standard Time"

# Määra kuvakeeleks English (United Kingdom)
Set-WinUILanguageOverride -Language en-GB
Set-WinUserLanguageList -LanguageList en-GB,et-EE -Force

# Lisa eesti keel sisestuskeeleks ja eemalda teised klaviatuurid ilma keelepaketti installimata
$LangList = New-WinUserLanguageList et-EE
$LangList[0].InputMethodTips.Clear()
$LangList[0].InputMethodTips.Add("0425:00000425") # Eesti klaviatuur
$LangList[0].Handwriting = $false # Väldib keelepaketi installi
Set-WinUserLanguageList -LanguageList $LangList -Force

# Määra piirkondlikud sätted Eesti peale
Set-WinHomeLocation -GeoId 70 # Eesti GeoID
Set-Culture et-EE
Set-WinSystemLocale et-EE

# Määra regionaalne formaat Estonia (Estonia)
Set-WinUILanguageOverride -Language en-GB
Set-WinUserLanguageList en-GB -Force
Set-Culture et-EE

# Keela täiendavate klaviatuuride lisamine
Set-WinUserLanguageList -LanguageList et-EE -Force

# Määra mitte-unicode programmide keeleks Eesti keel
Set-WinSystemLocale -SystemLocale "et-EE"

# Kopeeri sätted kõigile kasutajatele - kasutades Copy-UserInternationalSettingsToSystem
Copy-UserInternationalSettingsToSystem -WelcomeScreen $True -NewUser $True

Write-Host "Keele- ja piirkonnasätted on seadistatud!"