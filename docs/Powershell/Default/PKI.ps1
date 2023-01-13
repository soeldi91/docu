# Test RPC Connection
certutil -config - -ping <Server>\<IssuingCA>



# Get Certification

$TemplateName = "xxxxx"
$SubjectDNS = "$env:COMPUTERNAME.$env:USERDNSDOMAIN"
$SanEntries = $SubjectDNS
$URL =  "https://cep.xx.xx.ch/ADPolicyProvider_CEP_Kerberos/service.svc/CEP"


$Cert = Get-Certificate -SubjectName "CN=$SubjectDNS,O=xx,L=xx,S=xx,C=CH" -DnsName $SanEntries -Template $TemplateName -CertStoreLocation Cert:\LocalMachine\My -Url $URL