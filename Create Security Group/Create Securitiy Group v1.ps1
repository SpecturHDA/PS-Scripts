#Module Import
import-module activedirectory

#Prompted and Objects
$Name = (Read-Host -Prompt "Name")
$SamAccountName = (Read-Host -Prompt "Alais")
$OU = #Use ADSI Editor to update OU Path
$Description = (Read-Host -Prompt "Alias")

#Created Security Group
Write-Host "************************************************************************************"
Write-Host "Creating Security Group" -ForegroundColor Yellow
Write-Host "************************************************************************************"
New-ADGroup -Name $Name -SamAccountName $SamAccountName -GroupCategory Security -GroupScope Global -DisplayName $Name -Path $OU -Description "Members of this group are RODC Administrators" 
Write-Host "************************************************************************************"
Write-Host "Done!" -ForegroundColor Yellow
Write-Host "************************************************************************************"
