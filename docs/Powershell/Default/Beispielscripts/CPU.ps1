g$computername = hostname

Function Get-CPUNumber ($computername) {
    $CPUProperty = "NumberOfCores","NumberOfLogicalProcessors"
    $NumberOfCPUs = (Get-WmiObject -class win32_processor -computername $computername).Count
    $NumberOfCores = (Get-WmiObject -class win32_processor -computername $computername -Property $CPUProperty).NumberOfCores | Select-Object -First 1
    $NumberOfLogicalProcessors = (Get-WmiObject -class win32_processor -computername $computername -Property $CPUProperty).NumberOfLogicalProcessors | Select-Object -First 1
 
    $obj1 = new-object PSObject -Property @{"Number of CPUs"="$NumberOfCPUs";"Number of Cores/CPU"="$NumberOfCores";"Number of logical Processors/CPU"="$NumberOfLogicalProcessors"}
    $obj1 | Select-Object "Number Of CPUs", "Number of Cores/CPU", "Number of logical Processors/CPU" | Format-List
}