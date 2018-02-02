#Module Import
import-module activedirectory

#Prompted and Objects
$Name = (Read-Host -Prompt "Distrobution Group Name")
$Members = (Read-Host -Prompt "Members email addresses (Seperate each Email address with "," with no spaces.")

#Create Distrobution Group
Write-Host "************************************************************************************"
Write-Host "Creating Distrobution Group" -ForegroundColor Yellow
Write-Host "************************************************************************************"
New-DistributionGroup -Name $Name -Members $Members
Write-Host "************************************************************************************"
Write-Host "Done!" -ForegroundColor Yellow
Write-Host "************************************************************************************"

#Group Details
Write-Host "************************************************************************************"
Write-Host "New Group Details" -ForegroundColor Yellow
Write-Host "************************************************************************************"
Get-DistributionGroupMember -Identity $Name
Write-Host "************************************************************************************"
Write-Host "Done!" -ForegroundColor Yellow
Write-Host "************************************************************************************"
