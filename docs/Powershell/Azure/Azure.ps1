#Install-Module AzureAD
Install-Module -Name Az.Accounts -Scope CurrentUser
Import-Module -Name Az.Accounts

Install-Module -Name Az.Resources -Scope CurrentUser
Import-Module -Name Az.Resources

Install-Module -Name Az.Compute -Scope CurrentUser
Import-Module -Name Az.Compute

Install-Module -Name Az.Network -Scope CurrentUser
Import-Module -Name Az.Network

Install-Module -Name Az.Storage -Scope CurrentUser
Import-Module -Name Az.Storage

Install-Module -Name AzureRM -AllowClobber -Scope CurrentUser

Install-Module -Name AzureAD -Scope CurrentUser
Import-Module -Name AzureAD

Install-Module -Name AzureADPreview -Scope CurrentUser
Import-Module -Name AzureADPreview

Install-Module -Name MSOnline -Scope CurrentUser
Import-Module -Name MSOnline

# Azure AD Verbinden
connect-azuread
Connect-MsolService

Get-AzureADCurrentSessionInfo
Get-AzureADTenantDetail
Get-azureaaddomain


# Berechtigung / Rollen auslesen
$rolescollection = @()
$roles = Get-MsolRole
foreach($role in $roles)
{
    $members = Get-MsolRoleMember -RoleObjectId $role.ObjectId
    foreach($member in $members)
    {
        $obj = New-Object PSObject -Property @{
            RoleName = $role.Name
            MemberNAme = $member.DisplayName
            membertype = $member.RoleMemberType
        }
        $rolescollection += $obj
    }
} 
Write-Output $rolescollection | Sort-Object RoleName,MemberNAme  | format-tabel RoleNAme,MemberNAme,MemberType


#Find an existing user
Get-AzureADUser -SearchString "FR"

Get-AzureADUser -Filter "State eq 'SO'"

#Creating a new user
$user = @{
    City = "Oberbuchsiten"
    Country = "Switzerland"
    Department = "Information Technology"
    DisplayName = "Fred Feuerstein"
    GivenName = "Fred"
    JobTitle = "Azure Administrator"
    UserPrincipalName = "frFeuerstein@$domain"
    PasswordProfile = $PasswordProfile
    PostalCode = "4625"
    State = "SO"
    StreetAddress = "Hiltonstrasse"
    Surname = "Feuerstein"
    TelephoneNumber = "455-233-22"
    MailNickname = "FrFeuerstein"
    AccountEnabled = $true
    UsageLocation = "CH"
}

$newUser = New-AzureADUser @user

$newUser | Format-List

Get-AzureADUser -ObjectId  "damian.soldera@outlook.com" | Select-Object *


#WVD
Import-Module Az.Accounts
Import-Module Az.Compute
Import-Module Az.Network
Import-Module Az.Storage

$TenantID = "70829f03-a1f4-4952-9317-29e00ac1f2cd"
$imageVMName = "dvmwkptwvdimg01"
$resourceGroupName = "D-RGR-KPT-KPTDEV-WVDIMAGE-01"

Connect-AzAccount -Tenant $TenantID

Get-AzVM -Name $imageVMName -resourceGroupName $resourceGroupName





Connect-MsolService -Credential (Get-Credential)
Set-MsolADFSContext -Computer secure.swissic.ch
Get-MsolFederationProperty -DomainName xaas.swissic.ch| FL Source, TokenSigningCertificate