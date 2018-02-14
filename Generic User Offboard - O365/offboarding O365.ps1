#Login to Office365
clear-host
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -force
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session
Import-Module MsOnline
Connect-MsolService -Credential $UserCredential
Connect-AzureAD -Credential $UserCredential

#Prompt for username
$firstname = Read-Host -Prompt 'Enter the First Name (i.e. Jdoe)'
$lastname = Read-Host -Prompt 'Enter the Last Name (i.e. Jdoe)'
$username =  $Firstname.substring(0,1)+$lastname
$newPassword = (Read-Host -Prompt "Provide New Password")
$UPN = $username + "@" + (Get-ADDomain).dnsroot
$Email = 
$Licenses =


#Get the Mobile Devices associated with the O365 account
Write-Host "*********************************************"
Write-Host "Getting Mobile Devices Connected to Office365" -ForegroundColor Yellow
Write-Host "*********************************************"
Get-MobileDeviceStatistics -Mailbox $username | select DeviceFriendlyName,DeviceType,ClientVersion,LastSyncAttemptTime,AccountOnlyDeviceWipeRequestTime,LastAccountOnlyDeviceWipeRequestor,DeviceID
Write-Host "Done!"
Write-Host "*********************************************"

#List All Groups
Write-Host "*********************************************"
Write-Host "Gathering Groups Memberships for $Fullname" -ForegroundColor Yellow
Write-Host "*********************************************"
$userid = (get-azureaduser -objectid $Email).objectid
$groups = Get-AzureADUserMembership -ObjectId $userid
Write-Host "Done!"
Write-Host "*********************************************"

#Account Only Wipe devices
Write-Host "*********************************************"
Write-Host "Performing Account Only Wipes on Mobile Devices where possible (Exchange Activesync 16.1 and newer)" -ForegroundColor Yellow
Write-Host "*********************************************"
Get-MobileDeviceStatistics -Mailbox $username | where {$_.AccountOnlyDeviceWipeRequestTime -ne "$null"} | Clear-MobileDevice –AccountOnly
Write-Host "Done!"
Write-Host "*********************************************"

#Remove Device where Account Only Wipe not available
Write-Host "*********************************************"
Write-Host "Removing remaining Mobile Devices" -ForegroundColor Yellow
Write-Host "*********************************************"
Get-MobileDevice -Mailbox $username | where {$_.AccountOnlyDeviceWipeRequestTime -eq "$null"}  | Remove-MobileDevice
Write-Host "Done!"
Write-Host "*********************************************"

#Block login for account in O365
Write-Host "*********************************************"
Write-Host "Block login for account in O365 for '$Fullname'" -ForegroundColor Yellow
Write-Host "*********************************************"
Set-MsolUser -UserPrincipalName $UPN -BlockCredential $false
Write-Host "Done!"
Write-Host "*********************************************"

#Reset password for account in O365
Write-Host "*********************************************"
Write-Host "Reseting password for $Fullname" -ForegroundColor Yellow
Write-Host "*********************************************"
Set-MsolUserPassword -UserPrincipalName $username -NewPassword $newPassword
Write-Host "Done!"
Write-Host "*********************************************"

#Convert to shared mailbox
Write-Host "*********************************************"
Write-Host "Converting Office365 mailbox to a Shared Mailbox" -ForegroundColor Yellow
Write-Host "*********************************************"
Set-Mailbox –identity $username -Type shared
Write-Host "Done!"
Write-Host "*********************************************"

#Hide from GAL
Write-Host "*********************************************"
Write-Host "Hiding from the Global Address List" -ForegroundColor Yellow
Write-Host "*********************************************"
Set-Mailbox -Identity $username -HiddenFromAddressListsEnabled $true
Write-Host "Done!"
Write-Host "*********************************************"

#Grant requested supervisor full access permissions to user's mailbox
Write-Host "*********************************************"
Write-Host "Granting Full Access Permissions" -ForegroundColor Yellow
Write-Host "*********************************************"
$supervisor = Read-Host -Prompt 'Enter the supervisor''s username (leave blank for none)'
Add-mailboxpermission -identity $username -user $supervisor -accessrights fullaccess -automapping $true
Write-Host "Done!"
Write-Host "*********************************************"

#Remove all licensing for account in O365
Write-Host "*********************************************"
Write-Host "Removing all licensing for account in O365 for '$Fullname'" -ForegroundColor Yellow
Write-Host "*********************************************"
Set-MsolUserLicense -UserPrincipalName $Email -RemoveLicenses $Licenses
Write-Host "Done!"
Write-Host "*********************************************"

#Remove Remove all Groups
Write-Host "*********************************************"
Write-Host "Manully the following Groups from $Fullname"
Write-Host "*********************************************"
$groups
