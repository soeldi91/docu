#WMI Objekt (Windows Management Instrumentation)
# Alle Klassen ausgeben (Win32)
Get-WMIObject -List| Where-Object{$_.name -match "^Win32_"} | Sort-Object Name | Format-Table Name
Get-WmiObject -Class Win32_PNPEntity -Filter "Name='USB-Massenspeichergerät'" | Select Name, HardwareID

# Cim Instanzen
Get-CimInstance -ClassName win32_operatingsystem | select csname, lastbootuptime

# Disable Windows Defender
Set-MpPreference -DisableRealtimeMonitoring $true

# Windows Firewall
## Logging
get-NetFirewallProfile
Set-NetFirewallProfile -name domain -LogMaxSizeKilobytes 10240 -LogAllowed true -LogBlocked true
## Rules
get-NetFirewallRule | Where-Object DisplayName -like "*core*"
# Log: C:\Windows\System32\LogFiles\Firewall

# Windows Version anzeigen
[System.Environment]::OSVersion.Version

# Systeminformationen anzeigen
Systeminfo

# Informationen über das Pagefile.sys anzeigen
wmic pagefile list /format:list

# Bestimmten Prozess stoppen (Beispiel: Notepad)
Get-Process | Where-Object ProcessName -eq notepad | Stop-Process


# Alle angemeldeten Benutzer anzeigen
 query user /server:$SERVER

 #Message an alle angemeldeten Benutzer schicken
 msg * "Your message goes here"

# Alle Laufwerke und Mounts anzeigen
Get-psdrive

Get-WmiObject 

# Installed Packages (GUID)
get-wmiobject Win32_Product | Sort-Object -Property Name |Format-Table IdentifyingNumber, Name, LocalPackage -AutoSize


# Mapped VHDX trennen
$disks = Get-Disk | Where-Object FriendlyName -eq "Microsoft Virtual Disk" | Select-Object Path
foreach($disk in $disks){Dismount-DiskImage -DevicePath  $disk.Path}


# Treiber
# Alle signierte Treiber inklusiv Version anzeigen
Get-WmiObject Win32_PnPSignedDriver| Select-Object devicename, driverversion

# Alle installierte Treiber eines Remote-System anzeigen (mittels driverquery.exe)
driverquery /s $hostname /v /fo csv | ConvertFrom-Csv | Select-Object "Display Name", "Module Name", "Driver Type", "Link Date", "Start Mode", "Paged Pool(bytes)", "Path" | Sort-Object {$_."Link Date" -as [datetime]} | Format-Table


# Applikationen
$reportpath = read-host "Pfad für Ausgabe"
$reportpath
$InstalledSoftware = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"

foreach($obj in $InstalledSoftware)
{
    write-host $obj.GetValue('DisplayName') -NoNewline; write-host " - " -NoNewline; write-host $obj.GetValue('DisplayVersion')
}

$applications = Get-CimInstance win32_product | Select-Object Name, PackageName, InstallDate, InstallSource | Sort-Object Name$
$applications

# Netzwerk
Get-NetAdapter
Get-NetConnectionProfile | Select-Object *

Test-NetConnection 192.168.0.114

# PowerPlans / Energie
powercfg.exe list
powercfg.exe /query

# Regestry bearbeiten
Set-Location "HKCU:\Software"
Get-Childitem -Path "HKCU:\Software"
New-Item -Path "HKCU:\Software\Demontration" -Value "Demo"
## Example
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork"
$registryValueName = "DisablePostLogonProvisioning"
$registryValueData = "1"

New-Item -Path $registryPath -Force
New-ItemProperty -Path $registryPath -Name $registryValueName -Value $registryValueData -PropertyType DWORD -Force

# Windows Update
Install-PackageProvider -Name NuGet -Force
Install-Module -Name PSWindowsUpdate -Force
Import-Module -Name PSWindowsUpdate

## Find KBs
Get-WUHistory -Last 100
## Install Updates
Install-WindowsUpdate -MicrosoftUpdate -NotKBArticleID "$noKB" -NotTitle "cumulative" -AcceptAll -IgnoreReboot | Out-File "C:\Windows\Setup\logs\winupdatedetail.log" -force


#Check OS Version on USB Stick
DISM /get-wiminfo /wimfile:"G:\sources\boot.wim" /index:1
