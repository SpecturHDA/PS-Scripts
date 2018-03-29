$OUObjects=@('OU=centrexIT,DC=RDCSECURE,DC=COM','CN=Users,DC=RDCSECURE,DC=COM')
#$ou | foreach { get-aduser -searchbase $_ ...} 


<#$BillingOU = @("Yes","No")
$linecounter = 1
   foreach($Billing in $BillingOU){
           $linecounter++
    }
Write-host "`r`n"
$Check = $BillingOU[[int](Read-Host -Prompt "Will this user be in the billing office?")]
if($Check -eq "Yes")
{
        $UserOU = "OU=Billing,DC=BNMG,DC=NET"
    }
    else
     {#>

$OU = Get-ADOrganizationalUnit -Filter * -SearchBase $OUObjects -Properties * | select canonicalname | Out-String
    $OU = $OU.trim()
    $OU = $OU.Remove(0,242)
    $OUCanonical = $OU.Split("`n",$OU.Length)

    $OU = Get-ADOrganizationalUnit -Filter * -SearchBase $OUObjects -Properties * | select DistinguishedName | Out-String
    $OU = $OU.trim()
    $OU = $OU.Remove(0,242)
    $OUDistinguished = $OU.Split("`n",$OU.Length)

    $linecounter = 0

    foreach($item in $OUCanonical){
      Write-Host($linecounter.ToString() + ". " + $item)
      $linecounter++
    }
    Write-host "`r`n"
    $UserOU = $OUDistinguished[[int](Read-Host -Prompt "Please enter the number of the OU you wish to place this new user in (i.e. 1 or 17)")]