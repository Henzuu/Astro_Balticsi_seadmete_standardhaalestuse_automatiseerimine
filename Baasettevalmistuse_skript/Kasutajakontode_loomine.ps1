# Funktsioon kasutajanime kontrollimiseks
function KasutajaOlemas {
    param ($UserName)
    return Get-LocalUser -Name $UserName -ErrorAction SilentlyContinue
}

# Funktsioon parooli tugevuse kontrollimiseks
function KontrolliParooli {
    param ($Password)
    $paroolPikkus = $Password.Length -ge 12
    $paroolSuurTäht = $Password -match '[A-Z]'
    $paroolNumber = $Password -match '\d'
    $paroolSpetsSümbol = $Password -match '[\W_]'
    return $paroolPikkus -and $paroolSuurTäht -and $paroolNumber -and $paroolSpetsSümbol
}

# Funktsioon täpitähtede eemaldamiseks ja muude korrektuuride tegemiseks
function MuudaKasutajanimi {
    param ($UserName)
    $UserName = $UserName.ToLower() -replace '[^\w\s]', ''  # Muudab väikesteks tähtedeks ja eemaldab erimärgid, sh täpitähed
    $UserName = $UserName -replace 'ä', 'a' -replace 'ö', 'o' -replace 'ü', 'u' -replace 'õ', 'o'  # Täpitähtede asendamine
    $UserName = $UserName -replace ' ', '.'  # Asendab tühikud punktidega
    return $UserName
}

# Küsib, kas soovitakse kasutajat luua
$KasutajaLoomine = Read-Host "Kas soovid luua uue kasutaja? (jah/ei)"

# Kui kasutajat ei soovita luua, siis jätab kasutaja loomise vahele
if ($KasutajaLoomine -eq "jah") {
    do {
        # Küsib kasutajanime ja kontrollib, kas see on juba olemas
        do {
            $UserName = Read-Host "Sisesta kasutajanimi"
            $UserName = MuudaKasutajanimi $UserName  # Kasutajanime korrektuur

            if (KasutajaOlemas $UserName) {
                Write-Host "Palun vali teine kasutajanimi, see on juba olemas!" -ForegroundColor Red
            }
        } while (KasutajaOlemas $UserName)

        # Küsib täisnime
        $FullName = Read-Host "Sisesta täisnimi"

        # Valib, kas admin või tavakasutaja
        do {
            $UserType = Read-Host "Kas soovite luua administraatoriõigustega kasutaja? (jah/ei)"
        } while ($UserType -ne "jah" -and $UserType -ne "ei")

        # Küsib ja kinnitab parooli
        do {
            $Password1 = Read-Host "Sisesta parool (vähemalt 12 tähemärki, sisaldab suurt tähte, numbrit ja spetsiaalset sümbolit)" -AsSecureString
            $Password2 = Read-Host "Korda parooli" -AsSecureString

            # Muudame parooli tekstiks võrdlemiseks (ei salvesta niimoodi!)
            $BSTR1 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password1)
            $BSTR2 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password2)
            $PlainPassword1 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR1)
            $PlainPassword2 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR2)

            if ($PlainPassword1 -ne $PlainPassword2) {
                Write-Host "Paroolid ei ühti, proovi uuesti!" -ForegroundColor Red
            } elseif (-not (KontrolliParooli $PlainPassword1)) {
                Write-Host "Parool peab olema vähemalt 12 tähemärki pikk ning sisaldama vähemalt ühte suurt tähte, ühte numbrit ja ühte spetsiaalset sümbolit." -ForegroundColor Red
            }
        } while ($PlainPassword1 -ne $PlainPassword2 -or -not (KontrolliParooli $PlainPassword1))

        # Loob kasutaja parooliga
        $SecurePassword = ConvertTo-SecureString $PlainPassword1 -AsPlainText -Force
        New-LocalUser -Name $UserName -Password $SecurePassword -FullName $FullName -Description "Loodud skriptiga" -PasswordNeverExpires

        # Lisab kasutaja õigesse gruppi
        if ($UserType -eq "jah") {
            # Administraatori õigused: kasutaja lisatakse "Administrators" ja "Users" gruppidesse
            Add-LocalGroupMember -Group "Administrators" -Member $UserName
            Add-LocalGroupMember -Group "Users" -Member $UserName
            Write-Host "Administraatori õigustega kasutaja '$UserName' on loodud ja lisatud 'Administrators' ja 'Users' gruppidesse!" -ForegroundColor Green
        } else {
            # Tavaõigustega kasutaja: lisatakse "Users" ja "Remote Desktop Users" gruppidesse
            Add-LocalGroupMember -Group "Users" -Member $UserName
            Add-LocalGroupMember -Group "Remote Desktop Users" -Member $UserName
            Write-Host "Tavakasutaja '$UserName' on loodud ja lisatud 'Users' ja 'Remote Desktop Users' gruppidesse!" -ForegroundColor Green
        }

        # Küsimus, kas soovitakse veel kasutajat luua
        do {
            $Vasta = Read-Host "Soovid luua veel ühe kasutaja? (jah/ei)"
        } while ($Vasta -ne "jah" -and $Vasta -ne "ei")

    } while ($Vasta -eq "jah")
} else {
    Write-Host "Kasutaja loomine vahele jäetud." -ForegroundColor Cyan
}

Write-Host "Skript on lõpetanud töö!" -ForegroundColor Cyan