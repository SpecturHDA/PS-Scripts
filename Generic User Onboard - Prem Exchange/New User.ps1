#==================================================================================================
# Created by Darrell Tang 
# Additions By Chris Morris
# Last updates on 3/15/2018
# This Script should be run on the exchange server.
#==================================================================================================

clear-host
import-module activedirectory
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
$ScriptDirectory = $MyInvocation.MyCommand.Path
$ScriptDirectory = $ScriptDirectory.substring(0,$ScriptDirectory.LastIndexOf('\'))

. (Join-Path $ScriptDirectory UserOnboardFunctions.ps1)

#Create new AD User
Write-Host "*********************************************"
Write-Host "Create New AD User" -ForegroundColor Yellow
Write-Host "*********************************************"

$firstname = (Read-Host -Prompt "First Name")
$lastname = (Read-Host -Prompt "Last Name")
$fullname = $firstname + " " + $lastname
$samaccountname = (Read-Host -Prompt "Login Name (i.e. JSmith)")
#$samaccountname = $Firstname.substring(0,1)+$lastname
$UPN = $samaccountname + "@" + (Get-ADDomain).dnsroot
$newPassword = (Read-Host -Prompt "Provide New Password" -AsSecureString)
$OU = Get-ADOrganizationalUnit -Filter * -Properties * | select canonicalname | Out-String
    $OU = $OU.trim()
    $OU = $OU.Remove(0,242)
    $OUCanonical = $OU.Split("`n",$OU.Length)

    $OU = Get-ADOrganizationalUnit -Filter * -Properties * | select DistinguishedName | Out-String
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

$profilepath = (get-aduser templateuser -Properties *).profilepath
If ($profilepath -ne $null)
{
  $profilepath = $profilepath.substring(0,$profilepath.LastIndexOf('\')) + "\$samaccountname"
}
$homedrive = (get-aduser templateuser -Properties *).homedrive
$homedirectory = (get-aduser templateuser -Properties *).homedirectory
If ($homedirectory -ne $null)
{
  $homedirectory = $homedirectory.substring(0,$homedirectory.LastIndexOf('\')) + "\$samaccountname"
}
$scriptpath = (get-aduser templateuser -Properties *).scriptpath
$jobtitle = (Read-Host -Prompt "Job Title")
$department = (Read-Host -Prompt "Department")
$manager = (Read-Host -Prompt "Manager (i.e. Jdoe)")
if ($manager -like $null)
{
Write-host "No Manager Added"
}

new-aduser -name  $fullname -givenname $firstname -surname $lastname -displayname $fullname -userprincipalname $UPN -samaccountname $samaccountname -accountpassword $newPassword -path $UserOU -profilepath $profilepath -HomeDrive $homedrive -HomeDirectory $HomeDirectory -scriptpath $scriptpath -title $jobtitle -description $jobtitle -department $department -manager $manager -passthru | Enable-ADAccount

Start-Sleep -Milliseconds 2000
Write-Host "*********************************************"
Write-Host "User account created!" -ForegroundColor Yellow
Write-Host "*********************************************"

Get-ADUser -Identity $samaccountname -Properties * | fl displayname,userprincipalname,samaccountname,DistinguishedName,homedrive,Homedirectory,scriptpath,title,description,Department,manager,Enabled

Write-Host "*********************************************"
Write-Host "Create New user Mailbox" -ForegroundColor Yellow
Write-Host "*********************************************"
$Databaselist = Get-MailboxDatabase  | select -ExpandProperty Name
$linecounter = 1
   foreach($Databasename in $Databaselist){
      Write-Host($linecounter.ToString() + ". " + $Databasename)
      $linecounter++
    }
Write-host "`r`n"
$Database = $Databaselist[[int](Read-Host -Prompt "Please enter the number of the Mailbox Database you wish to place this new user in (i.e. 1 or 5)")-1]
Enable-Mailbox -Identity $samaccountname -Database $Database
Start-Sleep -Milliseconds 6000
Write-Host "*********************************************"
Write-Host "Mailbox created!" -ForegroundColor Yellow
Write-Host "*********************************************"

Write-Host "Select the default Distribution Group"
Write-Host "*********************************************"
$DistributionGrouplist = Get-DistributionGroup  | select -ExpandProperty Displayname
$linecounter = 1
   foreach($DistributionGroupname in $DistributionGrouplist){
      Write-Host($linecounter.ToString() + ". " + $DistributionGroupname)
      $linecounter++
    }
Write-host "`r`n"
$DistributionGroup = $DistributionGrouplist[[int](Read-Host -Prompt "Please enter the number of the Mailbox Database you wish to place this new user in (i.e. 1 or 5)")-1]
Write-Host "Adding to Default Distribution Groups" -ForegroundColor Yellow
Write-Host "*********************************************" -ForegroundColor Green
Add-DistributionGroupMember -Identity $DistributionGroup -Member $samaccountname
Write-Host "$samaccountname Added to Default Distribution Group!" -ForegroundColor Yellow
Write-Host "*********************************************" -ForegroundColor Green

Close PSSession
get-pssession | remove-pssession

Pause
