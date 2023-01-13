# Local Users
Die lokalen User werden im "trusted identity store" abgespeichert. --> Security Accounts Manager (SAM) database in der Registry

Die "local Users and Groups" Konsole ist in der Edition "Windows 10 Home" nicht vorhanden. Da muss das Control Penal verwendet werden.

# Data access and protection
## NTFS Permission
- Native files system für standard Fileserver
- File-level compression
- per-user volume quotas
- symbolic links and junction points
- volume sizes up to 256 TB
- Enterprise level file and folder encryption
- Support for bitlocker drive encryption
- Andere File Systeme
  - FAT16
  - FAT32
  - exFAT

**Basic Permissions**
- Full Control
- Modify
- Read & Execute
- List Folder Contents
- Read
- Write

**Move and Copy**
| Action   |      Effect     
|----------|:-------------:
| copy or move a file or folder to a different volume |  Inherits the permission from the destiantion 
| copy or move a file or folder within the sam NTFS volume |    Inhertis the permissions from the new parent folder and explicitly assigned permissions are retained and merged with the inherited permissions   
| copy a file or folder to a non-NTFS volume | the copy of the folder or file loses all permisions
| move a file or folder from NTFS to FAT | permission will be lost

**Effective Access**

<IMG  src="https://blog.foldersecurityviewer.com/wp-content/uploads/2017/06/EffectiveAccessTab.png" width="500">


## Sahred permission
New-SmbShare -Name MyShareName -Path C:\Temp\Data
Get-SmbShare
Get-SmbShareAccess
Grant-SmbShareAccess

# Local Policies
## Registry
- Path: %systemroot%\System32\Config\ (C:\Windows\System32\Config\)
  - SAM (Security Account Manager used to store local passwords)
  - SECURITY
  - SOFTWARE
  - SYSTEM
  - DEFAULT
  - USERDIFF (used only for Windows upgrades)

  