﻿<#$ActiveUsers = Get-ADUser –filter * -Properties passwordLastSet,whencreated,lastlogondate,Enabled,PasswordNeverExpires | Where { $_.passwordLastSet –eq $null –or $_.lastlogondate -gt (get-date).adddays(-90) } | Get-ADUser -Properties Name,lastlogondate | Select Name,lastlogondate#>

$ActiveUsers = Get-ADUser –filter * -Properties passwordLastSet,whencreated,lastlogondate,Enabled,PasswordNeverExpires | Where {$_.lastlogondate -gt (get-date).adddays(-90) -and $_.PasswordNeverExpires -eq $False -and $_.Enabled -eq $true} | Get-ADUser -Properties Name,lastlogondate | Select Name,lastlogondate

$Outofcompliance = Get-ADUser –filter * -Properties passwordLastSet,whencreated,lastlogondate,Enabled,PasswordNeverExpires | Where {$_.lastlogondate -gt (get-date).adddays(-90) -and $_.PasswordNeverExpires -eq $true -and $_.Enabled -eq $True} | Get-ADUser -Properties Name,lastlogondate | Select Name,lastlogondate
