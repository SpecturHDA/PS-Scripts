﻿
Search-ADAccount -UsersOnly -AccountInactive -TimeSpan 90 | ?{$_.enabled -eq $True} | Get-ADUser -Properties Name | Select Name