﻿$Databaselist = Get-MailboxDatabase  | select Name
$linecounter = 1
   foreach($Databasename in $Databaselist){
      Write-Host($linecounter.ToString() + ". " + $Databasename.Name)
      $linecounter++
    }
Write-host "`r`n"
$Database = $Databaselist[[int](Read-Host -Prompt "Please enter the number of the Mailbox Database you wish to place this new user in (i.e. 1 or 5)")-1]
