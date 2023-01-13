# Manage Windows Defender
## Windows Defender Credential Guard
Kerberos tickets und NTLM hashes werden im Local Security Authority gespeichert auf dem Windows Client.
Mit dem virtualization-assisted security wird der Zugriff auf das LSA geschützt.
- Benötigt ein TPM Chi und Virtualisierungs Funktionen

## Windows Defender Exploit Guard
- Exploit protection
- Attack surface reduction rules
- Network protection
- Controlled folder access


## Windows Defender Application Guard
Isoliert Browser Session indem sie in einer VM laufen gelassen werden.
- Benötigt ein TPM Chi und Virtualisierungs Funktionen

## Windows Defender Advanced Threat Protection 
- Attack surface reduction
- Endpoint detection and response
- Automated investigation and remediation
- Secure score
- Management and APIs

## Windows Defender Application Control
Damit kann gesteuert werden, welche Applikationen auf dem Cient erlaubt werden und welche nicht.
Alle unsignierten Apps werden geblockt.
- Die Microsoft Store Apps sind automatisch signiert.
- Mit der PKI kann man eigene Applikationen signieren
- Es können auch vertrauenswürdige (nicht-Microsoft) CA verwendet werden.
- Mit dem WDAC Signing Portal können auch Applikationen signiert werden

## Windows Defender Antivirus
- Computer Virus
- Computer Worms
- Trojanische Pferde
- Ransomeware
- Spyware

# Manage Intune Device Enrollment and inventory
Geräte können folgendermassen eingebunden (Enroll) werden:
- Add Work or Scholl account
- Enroll in MDM ONly (User-driven)
- Azure AD Join during OOBE
- Azure AD Join using Windows Autopilot
- Enroll in MDM only (using Device Enrollment Manager)
- Azure AD Join using bulk enrollment

# Monitor devices
Windows Analytics und Log Analytics benötigen eine Azure Subscription

# Desktop Analytics
Windows 8.1 und Windows 10
Endpoint Configuration Manager agent    