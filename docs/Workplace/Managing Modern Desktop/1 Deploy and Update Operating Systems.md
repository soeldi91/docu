## Plan and implement Windows 10 by using dynamic deployment

Dynamic provisioning sind nicht zum Updaten von Windows 10 sondern um es zu transferieren. Zum Beipsiel von WIn 10 PRo auf Win 10 Enterprise

Es gibt verschiedene Arten um die OS zu deployen
- Modern:
    - Enrollment into AzureActive Directory and Mobile Device Management (such as Microsoft Intune)
    - Provisioning packages using Windows Configuration Designer
        - To install a prov package Settings -> Accounts -> Access work or school -> Add or remove a provisioning package
        - Windows Configuration Designer --> Windows ADK or App from Microsoft Store
        - 1. Install the WCD -> 2. Run the provision kiosk devices project 3. copy the provisioning package to each computer 4. apply the provisioning package
    - Subscription Activation
        - Ab Windows 10 Pro - The Subscription Activation feature eliminates the need to manually deploy Enterprise or Education edition images on each target device,
    - Windows Autopilot 

- Alt:
    - Windows ADK 
    - Windows Deployment Services
        - Windows Deployment Services (WDS) enables you to deploy Windows operating systems over the network, which means that you do not have to install each operating system directly from a CD  or DVD.
    - Microsoft Deployment Toolkit
        - MDT is a unified collection of tools, processes, and guidance for automating desktop and server deployment.
            - Bootstrap.ini
            - CustomSettings.ini
            - Update Deployment Share
        1. Create a deployment share
        2. Add the windows 10 image
        3. Create a task sequence
    - System Center Configuration Manager

    - Bare-metal install
    - In-place upgrade
    - Wipe-and-load upgrade


Windows System Image Manager (SIM)
- Zum erstellen von Aswer Files (unantended)

# Plan and implement Windows 10 by using Windows Autopilot

Feature Update
Rollback Time = 10 Days

Enterprise State Roaming
- Theme
- Edge Browser Settings
- Passwords

## Azure Log Analytics
Für Log Analytics muss auf den Devices der Microsoft Monitor Agent installiert sein


# Upgrade devices to Windwos 10

Microsoft Assessment and Planning (MAP) Toolkit
The MAP Toolkit is used for multi-product assessment and planning. For example for the windows 10 readiness
Im Endpoint Manager ist das unter Desktop Analytics -> Deployment Plans

Von früheren Windows Version wieder zurück - Mit der Windows Recovery Options in den Settings
- Von Windows 10 auf 8.1 zurück - Nach 10 Tagen nicht mehr möglich

The ScanStage command is used with the User State Migration Tool (USMT) 10.0 to scan the source computer, collect the files and settings, and create a store
    scanstate.exe -> loadstate.exe

# Manage updates

WSUS
BranchCache


# Manage device authentication
