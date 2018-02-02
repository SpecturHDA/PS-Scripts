#Import AD
clear-host

#Pull Serial Number
Write-Host "*********************************************"
Write-Host "Checking Serial Number" -ForegroundColor Yellow
Write-Host "*********************************************"
Write-Host "Serial Number!" -ForegroundColor Yellow
c:\windows\system32\wbem\wmic.exe bios get serialnumber
Write-Host "*********************************************"