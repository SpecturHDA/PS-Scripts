Clear-Host

import-module activedirectory

$Activecount = (Get-ADUser  -Filter 'enabled -eq $True' | select -ExpandProperty Name).count
$Disabledcount = (Get-ADUser  -Filter 'enabled -eq $false' | select -ExpandProperty Name).count
$inactivecount = (Search-ADAccount -UsersOnly -AccountInactive -TimeSpan 30 | ?{$_.enabled -eq $True} | Get-ADUser -Properties Name | Select Name).count

Write-Host "**********************************************************"
Write-Host "Active directory report"
Write-Host "**********************************************************"
Write-Host "Current count for enabled Users:$Activecount "
Write-Host "Current count for disabled user:$disabledcount" 
Write-host "Currnet count of users who inactive for 30 days:$inactivecount"
write-host "**********************************************************"
Write-host "List of users who have been inactive for 30 or more days"
write-host "**********************************************************"
Search-ADAccount -UsersOnly -AccountInactive -TimeSpan 30 | ?{$_.enabled -eq $True} | Get-ADUser -Properties Name | Select Name
Write-host "**********************************************************"