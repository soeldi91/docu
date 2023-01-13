# Analyse was würde der Befehl bewirken
<Command> -WhatIf

# Zeigt an was er alles gemacht hat
<Command> -Verbose

# Eigenes PowerShell Profil anzeigen
$profile

# Format-Table
<Command> | Format-Table -Wrap -AutoSize

#Nach Befehlen suchen - Alle Befehle mit dem Suchstring VPN:
gcm *-*vpn*

# PowerShell-History durchsuchen (backsearch)
# Ctrl + R
# Suchbegriff eingeben

# Modulepath
$p = [Environment]::GetEnvironmentVariable("PSModulePath")


#Neues Objekt
$car =@
{
    Model = "Golf"
    Manufacturer = "VW"
    Color = "Red"
    Speed = "50"
}
$car = [PSCustomObject]$car
$car | Add-Member -Name tostring -MemberType ScriptMethod -value {$this | out-string} -force

# Remote
Invoke-Command -Computername $computername -ScriptBlock {}
# Datei über eine PowerShell Session auf eine VM kopieren (VMBus / Integrations Services)
$PSSession = New-PSSession -VMName 'Servername' -Credential (Get-Credential)
Copy-Item -ToSession $PSSession -Path C:\testfile.txt -Destination C:\
# Remote - Lokale Variable
$LokaleVariable = "Wert"
Invoke-Command -ComputerName $computername -ScriptBlock {
    $using:LokaleVariable
}

#WLAN Profile auslesen
netsh wlan export profile key=clear folder=C:\temp

# Gespeicherte Passwörter / PWD / Password
C:\Windows\System32\rundll32.exe keymgr.dll, KRShowKeyMgr

# Eventlog
# Letze 10 Application EventLogs anzeigen
Get-EventLog -Newest 10 -LogName "Application"
# Eventlogs mit WMI abfragen
Get-WmiObject Win32_NTLogEvent -Filter "LogFile='System' AND EventCode=7036" -ComputerName <Hostname>
# Eventlogs auf bestimmte EventIDs durchsuchen
Get-EventLog -LogName System -ComputerName <Hostname> | ? {$_.EventID -eq <EventID>}
# Eventlog-Eintrag erstellen (Dummy)
Write-EventLog –LogName System –Source “Microsoft-Windows-FailoverClustering” –EntryType Information –EventID 5121 -message "Manual"

# Invoke-RestMethod
Invoke-RestMethod -UseBasicParsing -Uri "https://YourURL" -Headers $header -Body ([System.Text.Encoding]::UTF8.GetBytes($JSON)) -ContentType application/json -Method Post

# Passwort
$VerschlüsseltesPW = Read-Host -Prompt "Enter your password" -AsSecureString  
$VerschlüsseltesPWalsText = $VerschlüsseltesPW | ConvertFrom-SecureString 
Write-Output $VerschlüsseltesPWalsText  
$VerschlüsseltesPWalsText | clip
 
Write-Output "Das oben angezeigte verschlüsselte Passwort ist bereits in die Zwischenablage kopiert worden!"

# Text to Speech
Add-Type -AssemblyName System.speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speak.Speak('Fuck you Robin')
#Installierte Stimmen anzeigen
$speak.GetInstalledVoices().VoiceInfo
#Stimme wechseln
$speak.SelectVoice('Microsoft Hazel Desktop')


# Startzeit eines Systems anzeigen
Get-CimInstance -ClassName win32_operatingsystem | select csname, lastbootuptime

# Array
$array = @()
$array = @("first","second")
$array -join "-"

$data = @(
       [pscustomobject]@{FirstName='Kevin';LastName='Marquette'}
       [pscustomobject]@{FirstName='John'; LastName='Doe'}
   )
$data += [pscustomobject]@{FirstName='Damian'; LastName='Soldera'}

# Hashtable
$myHashtable = @{
    Name     = 'Damian'
    Language = 'PowerShell'
    Ort      = 'Landquart'
}



$myObject = [pscustomobject]$myHashtable
$myObject | export-csv C:\Temp\object.csv -Delimiter ";" -Encoding Default -NoTypeInformation

# WMI Object
gwmi -list|where {$_.name -like "*system*"}
gwmi -class Win32_BIOS
gwmi -class Win32_useraccount

# Abkürzkungen / Programme / run
secpol.msc      Sicherheitseinstellungen
gpedit.msc      Gruppenrichtlinien
dsa.msc         Active Directory-Benutzer und -Computer	
compmgmt.msc    Computerverwaltung
diskmgmt.msc    Datenträgerverwaltung
services.msc    Dienste
dhcpmgmt.msc    DHCP
dnsmgmt.msc     DNS
eventvwr.msc    Ereignisanzeige
devmgmt.msc     Geräte-Manager
lusrmgr.msc     Lokale Benutzer und Gruppen
ncpa.cpl        Netzwerkverbindungen (Adapter)
appwiz.cpl      Programme und Funktionen
certmgr.msc     Zertifikat-Manager (User)
certlm.msc      Zertifikat-Manager (Computer)
desk.cpl        Anzeigeeinstellungen

# Credentials / Passwort / Passwörter
rundll32.exe keymgr.dll,KRShowKeyMgr