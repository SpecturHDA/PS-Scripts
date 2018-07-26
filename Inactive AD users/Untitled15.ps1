Get-Adgroups | Where {$_.memebers -and $_.Enabled -eq $true

Foreach
Get-ADUser –filter * -Properties passwordLastSet,whencreated,lastlogondate,Enabled,PasswordNeverExpires | Where {$_.lastlogondate -gt (get-date).adddays(-90) -and $_.PasswordNeverExpires -eq $False -and $_.Enabled -eq $true} | Get-ADUser -Properties Name,lastlogondate | Select Name,lastlogondate