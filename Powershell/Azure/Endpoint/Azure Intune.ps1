Install-Module AzureAD -Scope CurrentUser
Install-Module WindowsAutoPilotIntune -Scope CurrentUser
Install-Module MSOnline -Scope CurrentUser


Import-Module WindowsAutoPilotIntune
Import-Module AzureAD
Import-Module MSOnline

# Sample Scripts
$graph_api_samples = Set-Location "C:\Users\dsoldera\OneDrive - Inventx\Dokumente\Intune\Graph_API\"
$graph_api_samples

## Connect Microsoft Online Service 
Connect-MsolService

Get-MsolDevice -RegisteredOwnerUpn "damian.soldera@inventx.ch"
Get-MsolDevice -name "GK-DW1057B" | select *
$owner = "damian.soldera@inventx.ch"
Get-MsolDevice -name "DS-LT-L13" |% {if($PSItem.RegisteredOwners -like $owner) {$PSItem}}


## Connect Azure AD 
Connect-AzureAD -TenantId "c026f135-b0a2-4f4b-a803-001cde3f4027"
Get-AzureADDevice  -ObjectId 105956f6-f566-499a-9913-a124522f49e0
$displayname = "DS-LT-L13"
Get-AzureADDevice  |% {if($PSItem.DisplayName -like $displayname) {$PSItem | select * }  }


#Über Graph
Connect-MSGraph -AdminConsent
$Devices = Get-IntuneManagedDevice | Get-MSGraphAllPages 


foreach($device in $Devices )
{
    if($device.emailAddress -eq "damian.soldera@inventx.ch")
    {
        $device | select emailaddress,deviceName,deviceEnrollmentType,managedDeviceOwnerType,lastSyncDateTime
    }
}

$devices | select emailaddress,deviceName,deviceEnrollmentType,managedDeviceOwnerType,lastSyncDateTime | Sort-Object desc


Get-IntuneMobileApp 
Get-IntuneDeviceCompliancePolicy 
Get-IntuneDeviceCompliancePolicy -Select id, displayName, lastModifiedDateTime, assignments -Expand assignments | Where-Object {$_.assignments -match $Group.id}

# Device Configuration
Get-IntuneDeviceConfigurationPolicy
#oder 
$Resource = "deviceManagement/deviceConfigurations/"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=groupAssignments"
$DMS = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$AllDeviceConfig = $DMS.value
$AllDeviceConfig | Select-Object displayName,createdDateTime,lastModifiedDateTime,@{n="groupassignments";e={$_.groupassignments.targetGroupId}}
$OneDeviceConfig | Where-Object displayname -eq "DCP-macOS-BYOD-EndpointProtection-Default"
#Check Configurtaion Policy per Device
$devicename = "IX-AUTOPILOT-47"

Get-IntuneDeviceConfigurationPolicy | select displayName,createdDateTime,lastModifiedDateTime

#
$Resource = "deviceManagement/deviceManagementScripts"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)?`$expand=groupAssignments"
$DMS = Invoke-MSGraphRequest -HttpMethod GET -Url $uri
$AllDeviceConfigScripts = $DMS.value | Where-Object {$_.assignments -match $Group.id}
