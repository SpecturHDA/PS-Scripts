#Module Import
import-module activedirectory

#Prompted and Objects
$Alias = (Read-Host -Prompt "Alias of the Mailbox")
$Username = (Read-Host -Prompt "User who needs access")

#Grant Mailbox Access
Write-Host "************************************************************************************"
Write-Host "Set Mailbox access" -ForegroundColor Yellow
Write-Host "************************************************************************************"
Add-MailboxPermission -Identity $Alias -User $Username -AccessRights FullAccess -InheritanceType All
Write-Host "************************************************************************************"
Write-Host "Done!" -ForegroundColor Yellow
Write-Host "************************************************************************************"

Pause