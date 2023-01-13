# Exchange 2016

# Pagefile manuell angpassen
$computersys = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
$computersys.AutomaticManagedPagefile = $False
$computersys.Put()

$pagefile = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'"
$pagefile.InitialSize = 32778
$pagefile.MaximumSize = 32778
$pagefile.Put()

# Freischalten von RDP in der Windows Firewall
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Windows PreRequisites für Windows 2016
Install-WindowsFeature Server-Media-Foundation, NET-Framework-45-Features, RPC-over-HTTP-proxy, Failover-Clustering, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS, Telnet-Client

 #Server\V15 installiert.
.\Setup.exe /mode:Install /role:Mailbox /IAcceptExchangeServerLicenseTerms

## Exchange Mainanance Mode

# Starten des Maintenance Mode für die Transport Komponenten
Set-ServerComponentState VSCNEXCHANGE01 –Component HubTransport –State Draining –Requester Maintenance
# Damit der Maintenance Modus sofort aktiv wird, müssen die beiden Transport Services neu gestartet werden
Invoke-Command -ComputerName VSCNEXCHANGE01 {Restart-Service MSExchangeTransport}
Invoke-Command -ComputerName VSCNEXCHANGE01 {Restart-Service MSExchangeFrontEndTransport }
# Prüfen, ob die Queue leer ist
Get-Queue -Server VSCNEXCHANGE01 | Where-Object {$_.Identity -notlike '*\Poison' -and $_.Identity -notlike'*\Shadow\*'} | Select-Object Identity,MessageCount
# Verschieben der Mails in der Transport Queue auf einen anderen Exchange 2010 Server, falls die Queues nicht leer sind
Redirect-Message -Server VSCNEXCHANGE01 –Target VSCNEXCHAN01.churnet.net -Confirm:$false
# Aktivieren der Full Maintenance
Set-ServerComponentState VSCNEXCHANGE31 –Component ServerWideOffline –State InActive –Requester Maintenance
# Kontrolle der Konfiguration
Get-ServerComponentState VSCNEXCHANGE01


# Exchange Zertifikate prüfen
Get-ExchangeCertificate

# Virtual Directory
Get-OwaVirtualDirectory 
Get-EcpVirtualDirectory 
Get-ActiveSyncVirtualDirectory
Get-OabVirtualDirectory
Get-WebServicesVirtualDirectory 
Get-MapiVirtualDirectory 

# Aktivieren von MAPI over HTTP auf Stufe Organisation
Set-OrganizationConfig -MapiHttpEnabled $true

# Kontrolle aller URLs der virtuellen Verzeichnisse auf allen Exchange Servern
Get-OwaVirtualDirectory | Format-Table identity,InternalUrl,ExternalUrl
Get-EcpVirtualDirectory | Format-Table identity,InternalUrl,ExternalUrl
Get-ActiveSyncVirtualDirectory | Format-Table identity,InternalUrl,ExternalUrl
Get-OabVirtualDirectory | Format-Table identity,InternalUrl,ExternalUrl
Get-WebServicesVirtualDirectory | Format-Table identity,InternalUrl,ExternalUrl
Get-MapiVirtualDirectory | Format-Table identity,InternalUrl,ExternalUrl
Get-OutlookAnywhere | Format-Table Identity,InternalHostname,ExternalHostname
Get-ClientAccessService | Format-Table Name,AutodiscoverServiceInternalUri

# Disks formatieren
Format-Volume -DriveLetter K -FileSystem NTFS -AllocationUnitSize 65536 -SetIntegrityStreams:$false
Format-Volume -DriveLetter L -FileSystem NTFS -AllocationUnitSize 65536 -SetIntegrityStreams:$false
Format-Volume -DriveLetter M -FileSystem NTFS -AllocationUnitSize 65536 -SetIntegrityStreams:$false
Format-Volume -DriveLetter N -FileSystem NTFS -AllocationUnitSize 65536 -SetIntegrityStreams:$false
Format-Volume -DriveLetter O -FileSystem NTFS -AllocationUnitSize 65536 -SetIntegrityStreams:$false
Format-Volume -DriveLetter T -FileSystem NTFS -AllocationUnitSize 65536 -SetIntegrityStreams:$false

# DAG (Database Availability Group) erstellen
New-DatabaseAvailabilityGroup -Name CLCNEXCHANGE01 -WitnessServer vscninfraxxx01.churnet.net -WitnessDirectory F:\FSW_CLCNEXCHANGE01 -DatabaseAvailabilityGroupIPAddresses 10.50.144.230

# Datenbanken der DAG hinzufügen
Add-DatabaseAvailabilityGroupServer -Identity CLCNEXCHANGE01 –MailboxServer VSCNEXCHANGE01

# Datenbanken überprüfen
Get-MailboxDatabase -Status | sort-object name | Format-Table Name, Mounted, MountedOnServer –auto
Get-MailboxDatabaseCopyStatus –Server VSCNEXCHANGE01 | sort-object DatabaseName

# SMTP Domains überprüfen
Get-AcceptedDomain | Format-Table DomainName,DomainType


######## Exchange Online ######################

Connect-IPPSSession -UserPrincipalName admdsoldera@inventx.onmicrosoft.com

#Set Label Policy (Kein Default Outlook Label)
Set-LabelPolicy -Identity "Pilot - Öffentlich/Geschäftlich/Vertraulich" -AdvancedSettings @{OutlookDefaultLabel="None"}
Set-LabelPolicy -Identity "Pilot - Öffentlich/Geschäftlich/Vertraulich" -AdvancedSettings @{HideBarByDefault="False"}