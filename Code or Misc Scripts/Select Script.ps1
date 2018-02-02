#Select Script
Write-Host "*********************************************"
Write-Host "Which Script would you like to run" -ForegroundColor Yellow
Write-Host "*********************************************"
Write-Host ""
Write-Host ""
Write-Host "*********************************************"
$Script = (Read-Host -Prompt "Which Script would you like to run?")
invoke-expression -Command .\$Script