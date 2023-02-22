
# Übersicht der Angriffe

| Name                                | Jahr   | Beschreibung                                                                                                                                                                                                                                                                                                            |
|-------------------------------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Spectre und Meltdown               | 2018   | Sicherheitslücken in modernen Prozessoren, die es Angreifern ermöglichen, auf vertrauliche Daten zuzugreifen.                                                                                                                                                                                                            |
| WannaCry                            | 2017   | Ein Ransomware-Angriff, der Tausende von Computern weltweit infizierte und den Opfern Lösegeldzahlungen abverlangte.                                                                                                                                                                                                       |
| NotPetya                            | 2017   | Ein weiterer Ransomware-Angriff, der weltweit Unternehmen und Organisationen betraf, indem er ihre Computersysteme verschlüsselte und Lösegeldforderungen stellte.                                                                                                                                                       |
| Stuxnet                             | 2010   | Ein Virus, der speziell darauf ausgelegt war, industrielle Steuerungssysteme anzugreifen. Stuxnet wurde vermutlich von staatlich unterstützten Hackern entwickelt und zielt auf das iranische Atomprogramm ab.                                                                                                            |
| SQL-Injection                       | unbekannt | Eine Art von Angriff, die es Hackern ermöglicht, böswilligen Code in eine Website einzuschleusen, indem sie Schwachstellen in einer SQL-Datenbank ausnutzen.                                                                                                                                                              |
| Phishing                            | unbekannt | Eine Art von Angriff, bei dem ein Angreifer versucht, Benutzer dazu zu bringen, vertrauliche Informationen preiszugeben, indem er sich als vertrauenswürdige Quelle ausgibt, z.B. eine Bank oder ein Unternehmen.                                                                                                       |
| Distributed-Denial-of-Service (DDoS) | unbekannt | Eine Art von Angriff, bei dem ein Angreifer eine Website oder einen Server überlastet, indem er massenhaft Anfragen sendet, um die Verfügbarkeit zu beeinträchtigen oder zu blockieren.                                                                                                                                |
| Log4j                               | 2021   | Eine kritische Sicherheitslücke in der Java-basierten Logging-Bibliothek Log4j, die es Angreifern ermöglicht, Schadcode auszuführen und das betroffene System zu übernehmen, wenn es versucht, eine manipulierte Log4j-Konfigurationsdatei zu lesen. Die Auswirkungen sind weitreichend und betreffen viele Unternehmen und Organisationen. |



# Log4J


# Meltdown and Spectre
Meltdown and Spectre exploit critical vulnerabilities in modern processors. These hardware bugs allow programs to steal data which is currently processed on the computer. While programs are typically not permitted to read data from other programs, a malicious program can exploit Meltdown and Spectre to get hold of secrets stored in the memory of other running programs. This might include your passwords stored in a password manager or browser, your personal photos, emails, instant messages and even business-critical documents.

Meltdown and Spectre work on personal computers, mobile devices, and in the cloud. Depending on the cloud provider's infrastructure, it might be possible to steal data from other customers.

## Meltdown
Meltdown breaks the most fundamental isolation between user applications and the operating system. This attack allows a program to access the memory, and thus also the secrets, of other programs and the operating system.
If your computer has a vulnerable processor and runs an unpatched operating system, it is not safe to work with sensitive information without the chance of leaking the information. This applies both to personal computers as well as cloud infrastructure. Luckily, there are software patches against Meltdown.

## Spectre
Spectre breaks the isolation between different applications. It allows an attacker to trick error-free programs, which follow best practices, into leaking their secrets. In fact, the safety checks of said best practices actually increase the attack surface and may make applications more susceptible to Spectre.
Spectre is harder to exploit than Meltdown, but it is also harder to mitigate. However, it is possible to prevent specific known exploits based on Spectre through software patches.