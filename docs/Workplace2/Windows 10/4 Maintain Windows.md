# Backup and Restore
## Backup and Restore (Windows 7) Tool
The Backup and Restore (Windows 7) Tool can only be used to back up data that is stored on file system volumes formatted as NTFS
## Windows Backup Tool (WBAdmin.exe)
WBadmin get versions
WBadmin enable backup
WBadmin start backup
Wbadmin get items
WBadmin start recovery

WBadmin start backup -BackupTarget:E: -Include:C:
WBadmin get versions -backupTarget:E:
WBadmin start recovery -version:05/31/2022-17:15 itemType:Volume -items:\\?\Volume{34524523-345543-5345345-23435-345234}\ -BackupTarget:D: -RecoveryTarget:E:

The WBAdmin start recovery command is only supported in Windows RE and not in a normal Windows 10 administrative command prompt. Be careful because the drive letters of the mounted volumes can be different in Windows RE from those in Windows 10. You might need to replace the drive letters in your WBAdmin start recovery options.

# System and Data Recovery

# Windows Updates

# Monitor and Troubleshooting
## Event Logs


## Ressource Monitor


## Performance Monitor



# Credentials
cmdkey /list
rundll32.exe keymgr.dll,KRShowKeyMgr

