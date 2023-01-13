function get-directoryacls{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [Parameter(Mandatory = $true)]
        [string]
        $Exportpath

    )
    #### Auslesen der nicht vererbten Berechtigungen aller Verzeichnisse
    Set-StrictMode -Version "2.0"
    
    #DataTable anlegen
    $Properties = @("Ordnername","Identitaet","Berechtigungen","Vererbt","PropagationFlags","InheritanceFlags","IdentityReference")
    $DataTable=New-Object System.Data.DataTable("FileACL")
    $Properties | foreach {
    $Column = New-Object System.Data.DataColumn($_)
    $DataTable.Columns.Add($Column)
    }

    $i=0
    #DataTable befüllen
    Get-ChildItem $Path -Recurse -Attributes d | foreach{

    $FolderName = $_.FullName

    if (0 -eq $i % 20){
    Write-Host -NoNewline "`r$FolderName"
    } else {
    Write-Host -NoNewline "." }
    $i++


    $ACLs= @((Get-ACL $_.FullName).Access) | sort
    $ACLs | foreach{
    $Identity=$_.IdentityReference
    $FileSystemRights=$_.FileSystemRights
    $IsInherited=$_.IsInherited
    $PropagationFlags=$_.PropagationFlags
    $InheritanceFlags=$_.InheritanceFlags
    $IdentityReference=$_.IdentityReference
    $DataTable.Rows.Add($FolderName,$Identity,$FileSystemRights,$IsInherited,$PropagationFlags,$InheritanceFlags,$IdentityReference) | Out-Null
    }

    }
    #Datatable Filtern
    $Filter = "(Vererbt like 'False')"
    #$Filter = ""
    $FilteredDataTable = $DataTable.Select($Filter,$null)

    #DataTable ausgeben
    $FilteredDataTable | Format-Table OrdnerName,Identitaet,Berechtigungen,Vererbt,PropagationFlags,InheritanceFlags,IdentityReference -auto #Host
    $FilteredDataTable | Export-Csv "$Exportpath/all-Dirs.csv" -Delimiter ";" -Encoding Default #File
    $FilteredDataTable | select Ordnername,Vererbt | Export-Csv "$Exportpath/all-Dirs2.csv" -Delimiter ";" -Encoding Default #File
}


function Test-ixObjectExists {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("User","Group","OU","Other")]
        [string]
        $ObjectType,
        [Parameter(Mandatory = $true)]
        [string]
        $Identity,
        [Parameter(Mandatory = $false)]
        [string]
        $Server,
        [Parameter(Mandatory = $false)]
        [pscredential]
        $Credential
    )
    $properties = @{}
    if($ObjectType -eq "OU") {$properties.Filter = "DistinguishedName -eq `'$Identity`'" } else { $properties.Filter = "Name -eq `'$Identity`'" }
    $properties.ErrorAction = "SilentlyContinue"
    if(!([string]::IsNullOrEmpty($Server))) { $properties.Server = $Server }
    if(!([string]::IsNullOrEmpty($Credential))) { $properties.Credential = $Credential }

    switch ($ObjectType) {
        "User" {
            $obj = Get-ADUser @properties
        }
        "Group" {
            $obj = Get-ADGroup @properties
        }
        "OU" {
            $obj = Get-ADOrganizationalUnit @properties
        }
        Default {
            $obj = Get-ADObject @properties
        }
    }
    if($obj) { return $obj } else { return $false }
}

function New-ixGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [Parameter(Mandatory = $true)]
        [string]
        $Name,
        [Parameter(Mandatory = $false)]
        [string]
        $Description,
        [Parameter(Mandatory = $false)]
        [ValidateSet("Security")]
        [string]
        $GroupCategory = "Security",
        [Parameter(Mandatory = $true)]
        [ValidateSet("Global","DomainLocal")]
        [string]
        $GroupScope,
        [Parameter(Mandatory = $false)]
        [string]
        $Server,
        [Parameter(Mandatory = $false)]
        [pscredential]
        $Credential
    )
    $parameters = @{}
    $parameters.ObjectType = "Group"
    $parameters.Identity = $Name
    if(!([string]::IsNullOrEmpty($Server))) { $parameters.Server = $Server }
    if(!([string]::IsNullOrEmpty($Credential))) { $parameters.Credential = $Credential }
    $Group = Test-ixObjectExists @parameters
    
    if($Group -eq $false) {
        $properties = @{}
        $properties.Path = $Path
        $properties.Name = $Name
        $properties.SamAccountName = $Name
        $properties.GroupCategory = $GroupCategory 
        $properties.GroupScope = $GroupScope
        if(!([string]::IsNullOrEmpty($Server))) { $properties.Server = $Server }
        if(!([string]::IsNullOrEmpty($Description))) { $properties.Description = $Description }
        if(!([string]::IsNullOrEmpty($Credential))) { $properties.Credential = $Credential }

        try {
            $Group = New-ADGroup @properties -PassThru
        }
        catch {
            throw
        }
        
    }
    return $Group
}


####    RUN
$shares = @("\\pbdata01\Common$";`
            "\\pbdata01\userdata$";`
            "\\pbdata01\profils$";`
            "\\pbdata01\upm$";`
            "\\pbdata01\Intranet$";`
            "\\pbdata02\Invest$";`
            "\\pbdata02\Quant$";`
            "\\pbdata02\HCP$";`
            "\\pbdata02\Software$";`
            "\\pbdata02\CA-SFTP$";`
            "\\pbdata02\PBLUX$")

# groupmembership list
$curentfoldename = get-date -Format ddMMyyyy
$basepath = Join-Path -Path "C:\temp" -ChildPath $curentfoldename

if(Test-Path $basepath)
{}else{
    New-Item $basepath -ItemType Directory
}

foreach($share in $shares)
{
    $sharefoldername = $share -replace "\\",""
    $sharefoldername = $sharefoldername -replace "\$",""
    $sharefoldername = $sharefoldername -replace "pbdata02",""
    $sharefoldername = $sharefoldername -replace "pbdata01",""
    $exportpath = Join-Path -Path $basepath -ChildPath $sharefoldername
    if(Test-Path $exportpath)
    {}else{
        New-Item $exportpath -ItemType Directory
    }

    get-directoryacls -Path $share -Exportpath $exportpath
}




# All ACE Groups
# Auslesen aller Gruppen und Memberships / sowie erstellen des Gruppenmappings

$acls = @()
Get-ChildItem -Path $basepath -Recurse 'all-Dirs.csv' | % {$acls += import-csv -Delimiter ";" -Encoding Default -Path $_.FullName}

$AllGroups = $acls | select Identitaet -Unique | where {$_.Identitaet -like "pb\gs_file_*" -or $_.Identitaet -like "pb\gs_share_*" -or $_.Identitaet -like "pb\domain  users" -or $_.Identitaet -eq "pb\GS_Common_DG-Finance"}

$ExpandedGroups = @()
$ExpandedGroups += "GroupName;MemberName;MemberSamAccount;ARRGroupName"
foreach($grp in $AllGroups) {
    $grpObj = Get-ADGroup -Identity ($grp.Identitaet -replace "pb\\","")
    $members = Get-AdGroupMember -Identity $grpObj.DistinguishedName -Recursive
    foreach($member in $members) {
            $ExpandedGroups += "$($grpObj.Name);$($member.Name);$($member.SamAccountName);$($grpObj.Name -replace 'GS_','ARR-PB_' )"
    }
}

$ExpandedGroups | Out-File (Join-Path -Path $basepath -ChildPath "GroupsExpanded.csv") -Encoding Default


# @ Arrow Env
# Folgende Files muessen auf die RCB Admin Umgebung koppiert werden:
# GroupsExpanded.csv
# newIds.csv
# Alle ACL Lists



# AD Gruppen und Gruppenmemberships erstellen

$grpsA = Import-Csv -Path (Join-Path $basepath -ChildPath "GroupsExpanded.csv") -Delimiter ";"
$newIds = Import-CSV -Path (Join-Path $basepath -ChildPath "newIds.csv") -Delimiter ";"
$pathGrps = "OU=Resources,OU=Storage,OU=ixService,OU=ixCloud,DC=arrow,DC=rothschildandco,DC=ch"

foreach($grp in ($grpsA | select ARRGroupName -Unique)) {
    $grpobj = New-IxGroup -name $grp.ARRGroupName -path $pathGrps -Description "PB-Filermigration" -GroupScope DomainLocal
    foreach ($member in (($grpsA | where {$_.ARRGroupName -eq $grp.ARRGroupName}).MemberSamAccount)) {
        if($newIds.Old -contains $member) { $member = ($newIds | where {$_.old -eq $member}).New}
        #write-host "$($grp.ARRGroupName) kriegt member $member"
        try {
            Add-ADGroupMember -Identity $grp.ARRGroupName -Members $member
        }
        catch{
            write-host -ForegroundColor Red "$($grp.ARRGroupName);$member"
        }
    }
}


# AD Gruppen und Gruppenmemberships erstellen nur Pilotuser!!!

$grpsA = Import-Csv -Path (Join-Path $basepath -ChildPath "GroupsExpanded.csv") -Delimiter ";" -Encoding Default
$newIds = Import-CSV -Path (Join-Path $basepath -ChildPath "newIds.csv") -Delimiter ";" -Encoding Default
$pathGrps = "OU=Resources,OU=Storage,OU=ixService,OU=ixCloud,DC=arrow,DC=rothschildandco,DC=ch"

foreach($grp in ($grpsA | select ARRGroupName -Unique)) {
    #$grpobj = New-IxGroup -name $grp.ARRGroupName -path $pathGrps -Description "PB-Filermigration" -GroupScope DomainLocal
    foreach ($member in (($grpsA | where {$_.ARRGroupName -eq $grp.ARRGroupName}).MemberSamAccount)) {
        if($newIds.Old -contains $member) 
        { 
            $member = ($newIds | where {$_.old -eq $member}).New
            write-host "Gruppe wird erstellt; $($grp.ARRGRoupName)"
            write-host "$($grp.ARRGroupName); $member"
        try {
            $grpobj = New-IxGroup -name $grp.ARRGroupName -path $pathGrps -Description "PB-Filermigration" -GroupScope DomainLocal
            Add-ADGroupMember -Identity $grp.ARRGroupName -Members $member
        }
        catch{
            write-host -ForegroundColor Red "$($grp.ARRGroupName);$member"
        }
        }
    }
}


# Berechtigungen setzen auf RCB Filer

# ACL auslesen und Expanded ACL Liste erstellen
# Alle ACLs
$acls = @()
Get-ChildItem -Path $basepath -Recurse 'all-Dirs.csv' | % {$acls += import-csv -Delimiter ";" -Encoding Default -Path $_.FullName}

$sharename = Read-Host "Sharename (Bsp.: \\pbdata01\common$)?"

$acls = $acls | where {$_.Ordnername -like "$sharename*" -and ($_.Identitaet -like "pb\gs_file_*" -or $_.Identitaet -like "pb\gs_share_*" -or $_.Identitaet -like "pb\domain  users" -or $_.Identitaet -eq "pb\GS_Common_DG-Finance")}

# Ordnermapping
#\\pbdata01\Common$         \\rcbpf0001.arrow.rothschildandco.ch\oldshareddata\Common
#\\pbdata01\userdata$       \\rcbpf0001.arrow.rothschildandco.ch\oldhomedata\<username>\data
#\\pbdata01\profils$        \\rcbpf0001.arrow.rothschildandco.ch\oldhomedata\<username>
#\\pbdata01\upm$            --
#\\pbdata01\Intranet$       \\rcbpf0001.arrow.rothschildandco.ch\oldshareddata\Intranet

#\\pbdata02\Invest$         \\rcbpf0001.arrow.rothschildandco.ch\oldshareddata\Invest
#\\pbdata02\Quant$          \\rcbpf0001.arrow.rothschildandco.ch\oldshareddata\Quant
#\\pbdata02\HCP$            \\rcbpf0001.arrow.rothschildandco.ch\groups\HCP
#\\pbdata02\Software$       --
#\\pbdata02\CA-SFTP$
#\\pbdata02\PBLUX$ 

$ExpandedACL = @()
$ExpandedACL += "PB_GroupName;RCB_GroupName;PB_Ordnername;RCB_Ordnername;Berechtigungen;Vererbt;PropagationFlags;InheritanceFlags;IdentityReference"

foreach($acl in $acls)
{
    $Ordnername_RCB = $acl.Ordnername
    # OldHomedata
    if($Ordnername_RCB -like "\\pbdata01\userdata$*" -or $Ordnername_RCB -like "\\pbdata01\profils$*")
    {
        $ordnername_RCB = $Ordnername_RCB -replace 'pbdata01','rcbpf0001.arrow.rothschildandco.ch\<username>'
        $ordnername_RCB = $Ordnername_RCB -replace '\$',''
    }
    # groups
    elseif($Ordnername_RCB -like "\\pbdata02\HCP$*")
    {
        $ordnername_RCB = $Ordnername_RCB -replace 'pbdata02','rcbpf0001.arrow.rothschildandco.ch\groups\HCP'
        $ordnername_RCB = $Ordnername_RCB -replace '\$',''
    }
    # common / intranet
    elseif($Ordnername_RCB -like "\\pbdata01\Common$*" -or $Ordnername_RCB -like "\\pbdata01\Intranet$*")
    {
        $ordnername_RCB = $Ordnername_RCB -replace 'pbdata01','rcbpf0001.arrow.rothschildandco.ch\oldshareddata'
        $ordnername_RCB = $Ordnername_RCB -replace '\$',''
    }
    # Invest / Quant
    elseif($Ordnername_RCB -like "\\pbdata02\Invest$*" -or $Ordnername_RCB -like "\\pbdata02\Quant$*")
    {
        $ordnername_RCB = $Ordnername_RCB -replace 'pbdata02','rcbpf0001.arrow.rothschildandco.ch\oldshareddata'
        $ordnername_RCB = $Ordnername_RCB -replace '\$',''
    }
     # nomigration
     elseif($Ordnername_RCB -like "\\pbdata01\upm$*" -or $Ordnername_RCB -like "\\pbdata02\Software$*" -or $Ordnername_RCB -like "\\pbdata02\CA-SFTP$*" -or $Ordnername_RCB -like "\\pbdata02\PBLUX$ *")
    {
        $Ordnername_RCB = ""
    }


    $newgroup = $acl.Identitaet -replace 'GS_','ARR-PB_'
    $newgroup = $newgroup -replace "pb\\","ARROW\"

    $ExpandedACL += "$($acl.Identitaet);$newgroup;$($acl.Ordnername);$Ordnername_RCB;$($acl.Berechtigungen);$($acl.Vererbt);$($acl.PropagationFlags);$($acl.InheritanceFlags);$($acl.IdentityReference)"
     
}
$ExpandedACL | Out-File (Join-Path -Path $basepath -ChildPath "ACLExpended.csv") -Encoding Default



# ACL setzen

$ext_acls = Import-Csv -Path (Join-Path $basepath -ChildPath "ACLExpended.csv") -Delimiter ";" -Encoding Default
foreach($ext_acl in $ext_acls)
{
    write-host "Für den Ordner $($acl.Ordnername_RCB) wird die Berechtigung gesetzt"
    #$permission = $acl.Berechtigung
    $permission = "Read"
    $new_acl = Get-Acl $acl.Ordnername_RCB
    $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule($acl.Gruppe_RCB,$permission,$acl.InheritanceFlags, $acl.PropagationFlags,'Allow')
    $new_acl.SetAccessRule($Ar)

    #Set-Acl $acl.Ordnername_RCB $Acl
}

# ACL setzen nur Pilotuser!!!

$ext_acls = Import-Csv -Path (Join-Path $basepath -ChildPath "ACLExpended.csv") -Delimiter ";" -Encoding Default
foreach($ext_acl in $ext_acls)
{
    $adgroupname = $ext_acl.RCB_GroupName
    $adgroupname = $adgroupname -replace "ARROW\\",""
    $grouobj = Get-ADGroup -LDAPFilter "(SAMAccountName=$adgroupname)"
    if($grouobj -eq $null)
    {
        write-host "AD Gruppe $($ext_acl.RCB_GroupName) not exist jet" -ForegroundColor Red

    }else
    {
        write-host "Für den Ordner $($ext_acl.RCB_Ordnername) wird die Berechtigung gesetzt"
        #$permission = $ext_acl.Berechtigung
        $permission = "Read"
        $new_acl = Get-Acl $ext_acl.RCB_Ordnername
        $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule($ext_acl.RCB_GroupName,$permission,$ext_acl.InheritanceFlags, $ext_acl.PropagationFlags,'Allow')
        $new_acl.SetAccessRule($Ar)

        Set-Acl $ext_acl.RCB_Ordnername $new_acl
    }
}





### Profile und Userdata
# Die Profile werden per rsync hierhin migriert: Y:\Regent\profile
# Die Userdata werden per rsync hierhin migriert: Y:\Regent\data

# Dann werden sie per PS Script an das richtige Ort verschoben:
$all_profile = get-ChildItem -path "Y:\Regent\profile"
$newids = import-csv -path ".\newIds.csv" -Encoding default -Delimiter ";"
foreach($one_profile in $all_profile)
{
    Move-Item -Path $one_profile.FullName -Destination "Y:\"
    new-Item -path "Y:\$($one_profile.Name)" -Name "Userdata" -ItemType "directory"
}
$all_profiledata = get-ChildItem -path "Y:\Regent\data"
foreach($one_profiledata in $all_profiledata)
{
    $alldata = Get-ChildItem -path $one_profiledata.FullName
    foreach($data in $alldata)
    {
        Move-Item -Path $data.FullName -Destination "Y:\$($one_profiledata.Name)\Userdata\"
    }
    remove-Item $one_profiledata.FullName
}


# Zum Schluss noch die Berechtigung setzen für den User aus sein Ordner
$foldername = $all_profile.name
$profile = get-ChildItem -Path "\\rcbpf0001.arrow.rothschildandco.ch\oldhomedata" | where Name -eq $foldername

foreach($profil in $profile)
{
    #write-host " $($profil.Name)"
    $acls = get-acl -path $profil.FullName
    foreach($access in $acls.access)
    {
        if(!$access.IsInherited)
        {
            #write-host "Beim User $($profil.Name) ist $($access.IdentityReference.Value) berechtigt"
            $accessright = ($access.IdentityReference.Value.Split("\"))[1]
            if($accessright -ne $profil.Name)
            {
                write-host -ForegroundColor red "Achtung: Bei Ordner $profil"
            }
        }
    }
    $Username = "ARROW\$($profil.name)"
    if($newIds.Old -contains $profil.name) 
    { 
        $Username = ($newIds | where {$_.old -eq $profil.name}).New
        $profil = rename-item -path $profil.FullName -Newname $Username
        $profil = get-item -path "\\rcbpf0001.arrow.rothschildandco.ch\oldhomedata\$Username"
    }
    if($acls.access.IdentityReference -notcontains $Username)
    {
        write-host "Für das Profil: $profil wird die Berechtigung gesetzt für $Username"

        $Ar = New-Object System.Security.AccessControl.FileSystemAccessRule($Username, 'Modify','ContainerInherit,ObjectInherit', 'None', 'Allow') -ErrorAction Stop
        $acls.SetAccessRule($Ar)
        Set-Acl -path $profil.FullName -AclObject $acls -ErrorAction Stop
    }   
}


