Function Get-UserDisks {
    param(
        [string]$ComputerName
    )
 
    If (!($ComputerName)) {
        $ComputerName = $env:COMPUTERNAME
    }
 
    Get-WmiObject Win32_Volume -Filter "DriveType='3'" -ComputerName $ComputerName | ForEach {
        New-Object PSObject -Property @{
            Name = $_.Name
            Label = $_.Label
            FreeSpace_GB = ([Math]::Round($_.FreeSpace /1GB,2))
            TotalSize_GB = ([Math]::Round($_.Capacity /1GB,2))
        }
    }
}

gwm