#Install-Module AzureAD
Install-Module -Name Az.Accounts -Scope CurrentUser test
Import-Module -Name Az.Accounts

Install-Module -Name Az.Resources -Scope CurrentUser
Import-Module -Name Az.Resources

Install-Module -Name Az.Compute -Scope CurrentUser
Import-Module -Name Az.Compute

Install-Module -Name AzureAD -Scope CurrentUser
Import-Module -Name AzureAD

Install-Module -Name AzureADPreview -Scope CurrentUser
Import-Module -Name AzureADPreview

Install-Module -Name MSOnline -Scope CurrentUser
Import-Module -Name MSOnline

Get-Module -ListAvailable | Import-Module
Test
# Azure AD Verbinden
$tenantid = "70829f03-a1f4-4952-9317-29e00ac1f2cd"
$subscription = "d-sub-corekpt-dt-01"
Connect-AzAccount -Tenant $tenantid -Subscription $subscription

$ressourcegroup = "d-rgr-kpt-kptdev-wvdmanagement-01"
$vmname = "p-vmw-kpt-kptpw0011"
$diskname = "p-dad-kpt-kptpw0011-01"

$vm = Get-AzVM -ResourceGroupName $ressourcegroup -Name $vmname 
$disk = Get-AzDisk -ResourceGroupName $ressourcegroup -DiskName $diskname