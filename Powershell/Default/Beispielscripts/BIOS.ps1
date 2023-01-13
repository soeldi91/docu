$computername = hostname
$BIOSReport = @()

$BIOS = Get-WmiObject win32_bios -ComputerName $computername

$obj = New-Object -TypeName psobject
$obj | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $BIOS.PSComputerName
$obj | Add-Member -MemberType NoteProperty -Name "Manufacturer" -Value $BIOS.Manufacturer
$obj | Add-Member -MemberType NoteProperty -Name "Name" -Value $BIOS.Name
$obj | Add-Member -MemberType NoteProperty -Name "BIOS/UEFI Version" -Value $BIOS.SMBIOSBIOSVersion
$obj | Add-Member -MemberType NoteProperty -Name "SerialNumber" -Value $BIOS.SerialNumber
$obj | Add-Member -MemberType NoteProperty -Name "Version" -Value $BIOS.Version
$BIOSReport += $obj

$BIOSReport #| Sort-Object ComputerName | ft

