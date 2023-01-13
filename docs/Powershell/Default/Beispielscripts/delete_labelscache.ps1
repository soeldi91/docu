
$user = $env:Username

Remove-Item "C:\Users\$user\AppData\Local\Microsoft\MSIP\TokenCache" -Force -Confirm:$false
Remove-Item "C:\Users\$user\AppData\Local\Microsoft\MSIP\mip" -Force -Recurse -Confirm:$false
