#Module Import
import-module activedirectory

#Prompted and Objects
$Name = (Read-Host -Prompt "Distrobution Group Name")
$Members = (Read-Host -Prompt "Members email addresses (Seperate each Email address with "," with no spaces.")


#Created Distrobution Group
Write-Host "************************************************************************************"
Write-Host "Creating Distrobution Group" -ForegroundColor Yellow
Write-Host "************************************************************************************"
Add-DistributionGroupMember -Identity $Name -Member $Members
Write-Host "************************************************************************************"
Write-Host "Done!" -ForegroundColor Yellow
Write-Host "************************************************************************************"
