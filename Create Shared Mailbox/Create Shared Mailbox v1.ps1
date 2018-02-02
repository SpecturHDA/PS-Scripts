#Module Import
import-module activedirectory

#Prompted and Objects
$Name = (Read-Host -Prompt "Name")
$Displayname = (Read-Host -Prompt "Display Name")
$Alias = (Read-Host -Prompt "Alias")

#Created Shared Mailbox
Write-Host "************************************************************************************"
Write-Host "Creating Shared Mailbox" -ForegroundColor Yellow
Write-Host "************************************************************************************"
New-Mailbox -Shared -Name "$Name" -DisplayName "$Displayname" -Alias $Alias
Write-Host "************************************************************************************"
Write-Host "Done!" -ForegroundColor Yellow
Write-Host "************************************************************************************"

#Grant Mailbox Access
Write-Host "************************************************************************************"
Write-Host "Set Mailbox access" -ForegroundColor Yellow
Write-Host "************************************************************************************"
$Username = (Read-Host -Prompt "User who needs access")
Add-MailboxPermission -Identity $Alias -User $Username -AccessRights FullAccess -InheritanceType All
Write-Host "************************************************************************************"
Write-Host "Done!" -ForegroundColor Yellow
Write-Host "************************************************************************************"
