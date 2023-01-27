# Ports testen (Telnet Alternative)
Test-NetConnection <IP oder DNS-Namen> -Port <Port>

# Routing testen
Test-NetConnection -DiagnoseRouting

# Proxy
# Set WinHTTP Proxy with a bypass list (CIDR funktioniert nicht!)
netsh winhttp set proxy proxy-server="<your_proxy:port>" bypass-list="<*your_bypass.ch>"

#WinINet User:
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | fl *Auto*, *Proxy*
#WinINet Machine:
Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | fl *Auto*, *Proxy*
#WinHTTP User:
((Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Connections" -Name "WinHttpSettings") | ForEach{ [char]$_ }) -join "" -replace ([char]0)
#WinHTTP Machine:
((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Connections" -Name "WinHttpSettings") | ForEach{ [char]$_ }) -join "" -replace ([char]0)

#Don't forget the Proxy settings in context of NT Authority\System, for example the WinINet:

#Start PowerShell as System: .\psexec64.exe -i -s powershell.exe
#Type following and press Enter: inetcpl.cpl
# Change the Proxy settings: Connections -> LAN settings


# Internet Zone Assignments
$(get-item "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMapKey").property
$(get-item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMapKey").property


# Client Netzwerktreiber Metric
Get-NetIPInterface | Where-Object {$_.InterfaceAlias -contains "Ethernet"} | Set-NetIPInterface -InterfaceMetric 5


# Schneller Netzwerkscan
function Test-Port {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, HelpMessage = 'Could be suffixed by :Port')]
        [String[]]$ComputerName,

        [Parameter(HelpMessage = 'Will be ignored if the port is given in the param ComputerName')]
        [Int]$Port = 5985,

        [Parameter(HelpMessage = 'Timeout in millisecond. Increase the value if you want to test Internet resources.')]
        [Int]$Timeout = 1000
    )

    begin {
        $result = [System.Collections.ArrayList]::new()
    }

    process {
        foreach ($originalComputerName in $ComputerName) {
            $remoteInfo = $originalComputerName.Split(":")
            if ($remoteInfo.count -eq 1) {
                # In case $ComputerName in the form of 'host'
                $remoteHostname = $originalComputerName
                $remotePort = $Port
            } elseif ($remoteInfo.count -eq 2) {
                # In case $ComputerName in the form of 'host:port',
                # we often get host and port to check in this form.
                $remoteHostname = $remoteInfo[0]
                $remotePort = $remoteInfo[1]
            } else {
                $msg = "Got unknown format for the parameter ComputerName: " `
                    + "[$originalComputerName]. " `
                    + "The allowed formats is [hostname] or [hostname:port]."
                Write-Error $msg
                return
            }

            $tcpClient = New-Object System.Net.Sockets.TcpClient
            $portOpened = $tcpClient.ConnectAsync($remoteHostname, $remotePort).Wait($Timeout)

            $null = $result.Add([PSCustomObject]@{
                RemoteHostname       = $remoteHostname
                RemotePort           = $remotePort
                PortOpened           = $portOpened
                TimeoutInMillisecond = $Timeout
                SourceHostname       = $env:COMPUTERNAME
                OriginalComputerName = $originalComputerName
                })
        }
    }

    end {
        return $result
    }
}

$iprange = 0..255
$prefix = "192.168.1."
foreach($sufix in $iprange)
{
    $ip = $prefix+$sufix
    $result = Test-Port $ip 80
    if($result.PortOpened)
    {$result}
}


#Proxy PAC / Proxypac / WPAD / Autoprox
# Autoprox herunterladen und entpacken in C:\Temp
# https://docs.microsoft.com/en-us/troubleshoot/developer/browsers/connectivity-navigation/optimize-pac-performance

$url = "https://windows.net"
$proxypacfile = "https://pstofapendpointmgmt01.blob.core.windows.net/proxypac/kpt-proxy-test.pac"

Set-Location "C:\Temp\autoprox"
.\autoprox.exe -u:$url -p:$proxypacfile


# PowerShell über PRoxy Auth für z.B. System User
[System.Net.WebRequest]::DefaultWebProxy.Credentials =  [System.Net.CredentialCache]::DefaultCredentials
[System.Net.WebProxy]::new("http://10.32.2.130:8083",$true)
