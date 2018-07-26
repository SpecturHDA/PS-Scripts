#Import the AD Module for Powershell
Write-Host "*********************************************"
Write-Host "Importing AD Module for Powershell" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host "*********************************************"
Import-Module ActiveDirectory
Write-Host "Done!"
Write-Host "*********************************************"

#Prompt for username (SAMAccountName)
$username = Read-Host -Prompt 'Enter the username (i.e. Jdoe)'

#Get the Mobile Devices associated with the O365 account
Write-Host "*********************************************"
Write-Host "Getting Mobile Devices Connected to Office365" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host "*********************************************"
Get-ActiveSyncDeviceStatistics -Mailbox $username | select DeviceFriendlyName,DeviceType,ClientVersion,LastSyncAttemptTime,AccountOnlyDeviceWipeRequestTime,LastAccountOnlyDeviceWipeRequestor,DeviceID
Write-Host "Done!"
Write-Host "*********************************************"

#Remove Device where Account Only Wipe not available
Write-Host "*********************************************"
Write-Host "Removing remaining Mobile Devices" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host "*********************************************"
Get-ActiveSyncDevice -Mailbox $username | where {$_.AccountOnlyDeviceWipeRequestTime -eq "$null"}  | Remove-ActiveSyncDevice
Write-Host "Done!"
Write-Host "*********************************************"

#Disable account in AD
Write-Host "*********************************************"
Write-Host "Disabling AD Account for '$username'" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host "*********************************************"
Disable-ADAccount -Identity $username
Write-Host "Done!"
Write-Host "*********************************************"

#Reset Password
Write-Host "*********************************************"
Write-Host "Resetting the AD password for '$username'" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host "*********************************************"
$newPassword = (Read-Host -Prompt "Provide New Password" -AsSecureString)
Set-ADAccountPassword -Identity $username -NewPassword $newPassword -Reset
Write-Host "Done!"
Write-Host "*********************************************"

#Move user to “PCSD\Disabled Users” OU
Write-Host "*********************************************"
Write-Host "Moving AD User '$username' to OU: PCSD\Disabled Users" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host "*********************************************"
Get-ADUser $username | Move-ADObject -TargetPath 'OU=Disabled Users,OU=PCSD,DC=PMCSD,DC=local'
Write-Host "Done!"
Write-Host "*********************************************"

#Document existing AD groups in CW ticket, then remove user from all groups except domain users.
Write-Host "*********************************************"
Write-Host "Please document the Group Membership for '$username' below" -ForegroundColor Yellow -BackgroundColor DarkGreen
Get-ADPrincipalGroupMembership –identity $username | Select-Object name
Write-Host "Removing Group Memberships"
Get-ADPrincipalGroupMembership -Identity $username | % {Remove-ADPrincipalGroupMembership -Identity $username -Confirm:$False -MemberOf $_ -EA SilentlyContinue}
Write-Host "Done!"
Write-Host "*********************************************"

#Hide from GAL
Write-Host "Hiding '$username'@pcsd.net from the Global Address List" -ForegroundColor Yellow -BackgroundColor DarkGreen
Set-ADUser $username -Replace @{msExchHideFromAddressLists="TRUE"}
Write-Host "Done!"
Write-Host "*********************************************"


Pause