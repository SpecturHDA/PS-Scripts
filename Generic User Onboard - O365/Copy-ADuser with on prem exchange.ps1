clear-host
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -force
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session
Import-Module MsOnline
Connect-MsolService -Credential $UserCredential
import-module activedirectory
$ScriptDirectory = $MyInvocation.MyCommand.Path
$ScriptDirectory = $ScriptDirectory.substring(0,$ScriptDirectory.LastIndexOf('\'))

#Create new AD User
Write-Host "*********************************************"
Write-Host "Create New AD User" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host "*********************************************"

$firstname = (Read-Host -Prompt "First Name")
$lastname = (Read-Host -Prompt "Last Name")
$fullname = $firstname + " " + $lastname
$samaccountname = $Firstname.substring(0,1)+$lastname
$UPN = $samaccountname + "@" + (Get-ADDomain).dnsroot
$newPassword = (Read-Host -Prompt "Provide New Password" -AsSecureString)
$Copyuser = (Read-Host -Prompt "Username of the account you are copy permissions from")
$OU = (Get-AdUser $Copyuser).distinguishedName.Split(',',2)[1]
$LicenseAssignment = (Read-Host -Prompt "Office360 License")
$UserPrincipalName = (Read-Host -Prompt "Email Address for O365")

$profilepath = (get-aduser $Copyuser -Properties *).profilepath
If ($profilepath -ne $null)
{
  $profilepath = $profilepath.substring(0,$profilepath.LastIndexOf('\')) + "\$samaccountname"
}
$homedrive = (get-aduser $Copyuser -Properties *).homedrive
$homedirectory = (get-aduser $Copyuser -Properties *).homedirectory
If ($homedirectory -ne $null)
{
  $homedirectory = $homedirectory.substring(0,$homedirectory.LastIndexOf('\')) + "\$samaccountname"
}
$scriptpath = (get-aduser $Copyuser -Properties *).scriptpath
$jobtitle = (Read-Host -Prompt "Job Title")
$department = (Read-Host -Prompt "Department")
$manager = (Read-Host -Prompt "Manager (i.e. Jdoe)")

new-aduser -name  $fullname -givenname $firstname -surname $lastname -displayname $fullname -userprincipalname $UPN -samaccountname $samaccountname -accountpassword $newPassword -path $OU -profilepath $profilepath -HomeDrive $homedrive -HomeDirectory $HomeDirectory -scriptpath $scriptpath -title $jobtitle -description $jobtitle -department $department -manager $manager -passthru | Enable-ADAccount

Start-Sleep -Milliseconds 2000
Write-Host "*********************************************"
Write-Host "User account created!" -ForegroundColor Yellow
Write-Host "*********************************************"

#Copy Groups from templete user
Get-ADUser -Identity $Copyuser -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members $samaccountname -PassThru | Select-Object -Property SamAccountName
Write-Host "*********************************************"
Write-Host "New user added to above groups!" -ForegroundColor Yellow
Write-Host "*********************************************"

#Account Details
Write-Host "*********************************************"
Write-Host "AD account details:" -ForegroundColor Yellow
Write-Host "*********************************************"
Get-ADUser -Identity $samaccountname -Properties * | fl displayname,userprincipalname,samaccountname,DistinguishedName,homedrive,Homedirectory,scriptpath,title,description,Department,manager,Enabled

#Create user account
New-MsolUser -DisplayName $fullname -FirstName $firstname -LastName $lastname -UserPrincipalName $UserPrincipalName -UsageLocation US -Password Default123 -LicenseAssignment $LicenseAssignment
Write-Host "*********************************************"
Write-Host "User account created!" -ForegroundColor Yellow
Write-Host "*********************************************"

#Pause to allow mailbox creation (Can be removed if not using office365 exchange)
Write-Host "Mailbox is being provisioned please wait..."
Start-Sleep -Milliseconds 180000
Write-Host "*********************************************"
Write-Host "Mailbox Created!" -ForegroundColor Yellow
Write-Host "*********************************************"

#Close PSSession
#get-pssession | remove-pssession

Pause
