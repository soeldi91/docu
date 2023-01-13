# Move Item
Move-Item -Path "Microsoft.PowerShell.Core\FileSystem::\\<Hostname>\C$\temp\testfile.txt" -Destination "Microsoft.PowerShell.Core\FileSystem::\\<Destination-Hostname>\C$\temp\testfile.txt"

# Extend the drive/volume (with all free space)
$DriveLetter = "C"; Resize-Partition -DriveLetter $DriveLetter  -Size ((Get-PartitionSupportedSize -DriveLetter $DriveLetter).SizeMax)

#Free Disk Space
$Hostname = Read-Host "Geben Sie den Hostname des Systems an:"
Get-WMIObject Win32_Logicaldisk -filter "deviceid='C:'" -ComputerName $Hostname | Select-Object PSComputername,DeviceID,
@{Name="SizeGB";Expression={$_.Size/1GB -as [int]}},
@{Name="FreeGB";Expression={[math]::Round($_.Freespace/1GB,2)}}


#Mount/Dismount VHD/VHDX
Mount-VHD –Path "<full_path_to_vhd>"
Dismount-VHD –Path "<full_path_to_vhd>"