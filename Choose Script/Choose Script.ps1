Split-Path -Parent $PSCommandPath

Write-Host "1: Script1" -ForegroundColor Yellow
Write-Host "2: Script2" -ForegroundColor Yellow
Write-Host "3: Script3" -ForegroundColor Yellow
$Scripts = @("Script1","Script2","Script3")
$linecounter = 1
   foreach($Scriptlist in $Scripts){
           $linecounter++
    }
Write-host "`r`n"
$Script = $Scripts[[int](Read-Host -Prompt "Please Select a Script to execute (i.e. 1,2,or3)")-1]
invoke-expression -Command .\$Script