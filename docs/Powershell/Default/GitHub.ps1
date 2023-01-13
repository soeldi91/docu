# 1. GIT Bash installieren

git config --global --list
git config --global user.name Damian Soldera
git config --global user.email damian.soldera@swissic.ch
git config --global http.proxy http://xaas\dsoldera@clientproxy.xaas.swissic.ch:8080
git config --global https:.proxy http://xaas\dsoldera@clientproxy.xaas.swissic.ch:8080
git config --global http.sslVerify false


# Beispiel: git clone https://jg2xovac5dfzq4flybggryiirqjxzq6khefa4vqqquguecdbrzna@pbihagch.visualstudio.com/IHA-Entpoint-Management/_git/02-IHA-USBStaging

#Repo Klonen
git clone <URL>
git pull

<# GIT Things
Stay up to date - Bevor du mit der Arbeit beginnst und Änderungen vornimmst, immer zuerst die neusten Änderungen vom Remote Repository abholen 
git pull

Commit often - Commite früh und oft, nur so kann man Vorteile von Git wie git revert sinnvoll nutzen 
git commit

Good commit messages - Erstelle präzise und prägnante commit Meldungen damit die git History gut lesbar ist (Verweise auf CR oder INC Nummern) 
git commit -am "Some good text"

Work with branches - Erstelle Branches für grössere Änderungen damit du deine Kollegen nicht blockierst 
git branch my_feature_branch

Keep your branch up to date - Stell sicher das dein Feature Branch regelmässig die Änderungen vom master Branch reinholt um grosse merge Konflikte beim Abschluss der Änderungen zu vermeiden 
git merge

Work with merge requests - Arbeite mit Merge Requests um kritische Änderungen reviewen zu lassen und Know-How zu verteilen
Git - Merge Requests

- Don't use the force option - Die --force Option sollte nie verwendet werden da dann Änderungen überschrieben werden → Merge Konflikte zeitnah lösen um grosse Merge Aktionen zu vermeiden
#>


//List project name
$connectionToken="PAT"
$base64AuthInfo= [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($connectionToken)"))
$ProjectUrl = "https://dev.azure.com/statusworks/SWO-AVD-Spoke/_apis/git/repositories?api-version=6.1-preview.1" 
$Repo = (Invoke-RestMethod -Uri $ProjectUrl -Method Get -UseDefaultCredential -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)})
$RepoName= $Repo.value.name
Write-Host  $RepoName