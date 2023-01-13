Connect-AzAccount -Tenant kptch.onmicrosoft.com

$groups = Get-AzAdGroup

Foreach ($group in $groups) {
    $members = (Get-AzADGroupMember -GroupObjectId $group.Id).userPrincipalName -join ','
    $groupInfo = [PSCustomObject]@{
        GroupName = $group.DisplayName
        Members=$members
    }
    $groupInfo
    $report += $groupInfo
}




Get-Azurermressourcegroup
