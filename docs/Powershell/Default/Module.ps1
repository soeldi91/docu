# Zum installieren von Modulen über den Proxy
[System.Net.WebRequest]::DefaultWebProxy.Credentials =  [System.Net.CredentialCache]::DefaultCredentials
[System.Net.WebProxy]::new("http://10.32.2.130:8083",$true)
Register-PSRepository -Default

# Zugriff notwendig! 
#    onegetcdn.azureedge.net - CDN hostname
#    psg-prod-centralus.azureedge.net - CDN hostname
#    psg-prod-eastus.azureedge.net - 
# https://docs.microsoft.com/en-us/powershell/scripting/gallery/getting-started?view=powershell-5.1#network-access-to-the-powershell-gallery


# PowerShell verfügbare Module anzeigen
Get-Module -ListAvailable

# Funktionen bzw. Commands eines Modules anzeigen
Get-Command -Module Az.Accounts

$env:PSModulePath
#C:\Users\dsoldera\OneDrive - Inventx\Dokumente\WindowsPowerShell\Modules
#C:\Program Files\WindowsPowerShell\Modules
#C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules


$modules = Import-Csv -path ".\powershell_scripts\Default\module.csv"



foreach($module in $modules)
{
    if(get-module -Name $module.Name)
    {
        Install-Module -name $module.Name
        Import-Module -Name $module.Name
    }
}

Get-Module -ListAvailable
#Funktionen im Module prüfen
Get-Command -Module DnsClient
