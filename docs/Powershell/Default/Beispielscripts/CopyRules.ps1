<#
.Synopsis
   Verschiebt die Appmasking Rules auf die Worker beim Reboot
.DESCRIPTION
   Verschiebt die Appmasking Rules auf die Worker beim Reboot
.NOTES
   05.01.2021 dsoldera
.FUNCTIONALITY
   Verschiebt die Appmasking Rules auf die Worker beim Reboot
#>

$SourceDir = "\\ixfiler001.inventx.ch\AppData\ComputerScripts\ixBYOD\TS2019\FSLogix_Maskingrules\W10_WS2019_O365\*"
$RulesDir = "C:\Program Files\FSLogix\Apps\Rules"

If (Test-Path $RulesDir) {
Remove-Item $RulesDir\*.* -Force
Copy-Item $SourceDir -destination $RulesDir}

