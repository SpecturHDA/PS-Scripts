$OUlist = Get-ADOrganizationalUnit -Filter * -SearchBase "OU=Offices,DC=BNMG,DC=NET" -Properties canonicalname | select canonicalname
$linecounter = 1
   foreach($OUname in $OUlist){
      Write-Host($linecounter.ToString() + ". " + $OUname)
      $linecounter++
    }
Write-host "`r`n"
$OU = $OUlist[[int](Read-Host -Prompt "Please enter the number of the Mailbox Database you wish to place this new user in (i.e. 1 or 5)")-1]
$OU