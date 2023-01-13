# Für eizelne Benutzer Berechtigung auf User Folder setzen

$HomeFolders = Get-ChildItem .\ -Directory
foreach ($HomeFolder in $HomeFolders) {
    $Path = $HomeFolder.FullName
    $Acl = (Get-Item $Path).GetAccessControl('Access')
    $Username = "XXX\$($HomeFolder.Name)"
                try {
                    $usersid = New-Object System.Security.Principal.Ntaccount($Username) -ErrorAction Stop
                    $sid = $usersid.Translate([System.Security.Principal.SecurityIdentifier]).value
                }
                catch {
                               Write-Host -foregroundcolor red  "Error translating $($HomeFolder.Name)"
                               continue
                }
                try {
                    $Ar = New-Object System.Security.AccessControl.FileSystemAccessRule($Username, 'Modify','ContainerInherit,ObjectInherit', 'None', 'Allow') -ErrorAction Stop
                    $Acl.SetAccessRule($Ar)
                    Set-Acl -path $Path -AclObject $Acl -ErrorAction Stop
                }
                catch {
                               write-Host -foregroundcolor red "ACL failed for user $($HomeFolder.Name)"
                }
   write-host -foregroundcolor green "ACL done for user $($HomeFolder.Name)"
}
