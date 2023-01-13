$citrix_vdas = "ixpw647","ixpw648","ixpw649","ixpw651","ixpw646","ixpw665","ixpw650","ixpw666","ixpw634","ixpw657","ixpw658","ixpw659","ixpw660","ixpw662","ixpw663","ixpw664","ixpw655","ixpw656","ixpw667","ixpw671","ixpw668","ixpw669","ixpw670","ixpw632","ixpw633","ixpw635","ixpw636","ixpw661","ixpw637","ixpw638","ixpw639","ixpw640","ixpw631","ixpw630","ixpw644"

$allebenutzer = @()
$einbenutzer = @{}

foreach($citrix_vda in $citrix_vdas)
{

    $users = get-childitem "\\$citrix_vda\c$\Users"
    foreach($benutzer in $users.name)
    {
        if($benutzer -notlike "local_*"-and  $benutzer -ne "Administrator" -and $benutzer -ne "Public")
        {
            if($allebenutzer.Name -contains $benutzer)
            {
                Write-Host "$benutzer hat mehrere Profile gemappt!"
                $citrix_vda  
                foreach($nichtallebenutzer in $allebenutzer)
                {
                    if($nichtallebenutzer.name -eq "$benutzer")
                    {
                        write-host $nichtallebenutzer.Server
                    }
                }
                
                $einbenutzer = @{Name = $benutzer; Server = $citrix_vda}
                $allebenutzer += $einbenutzer

                write-host "------------------------------"
            }
            else
            {
                $einbenutzer = @{Name = $benutzer; Server = $citrix_vda}
                $allebenutzer += $einbenutzer
            }
            #$user
        }
    }
}
