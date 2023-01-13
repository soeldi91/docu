# Plan and implement co-management
# Implement conditional access and compliance policies for devices

- Compliance Policy and Device Profiles
    - Refresh Cycle
        IOS         Ever 15 Minutes for 6 hours, and then every 6 hours 
        macOS       Ever 15 Minutes for 6 hours, and then every 6 hours
        Android     Every 3 Minutes fpr 15 Minutes, then every 15 minutes for 2 hours, and then every 8 hours
        Windows 10  Every 3 Minutes fpr 30 Minutes, and then every 8 hours

# Configure device profiles

Intune support
- Apple iOS 9.0 and later
- Mac OS X 10.9 and later
- Android 4.4 and later (including Sasmsung Knox 4.4 and later and Android for Work)
- Windows Phone 8.1, Windows RT 8.1, and Windows 8.1 (sustaining mode)
- Windows 10 and Windows 10 Mobile
- Windows 10 IoT Enterprise and Windows 10 Mobile Enterprise

- OMA-URI = Open Mobile Alliance Uniform Resource Identifier

# Manage user profiles

Every new local user profile is based on the Default profile in the Users folder 
A user profile consists of two elements
- A regisrty hive
    - NTuser.dat --> this file will be loaded at logon and will be mapt to the HKEY_CURRENT_USER registry subtree
- A set of profile folders stored in the file system

User Profile Types
- Local User Profile
- Roaming User Profile
- Mandatory User Profile
- Super-Mandatory USer PRoifle
- Temporary User Profile

## Device Sync Settings

## OneDrive Know Folder Move

## Enterprise State Roaming
When user is deleted - ESR will be deleted after 90-180 days
