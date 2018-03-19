#==================================================================================================
# Created by Christopher D. Morris 
# Created On: 3/15/2018
# Additions By:
# Updated On: 
# This Script should be run on the exchange server.
#==================================================================================================

#Objects
Write-host "***************************************************************"
Write-host "Please update the following objects"
Write-host "***************************************************************"
$OU = (Read-Host -Prompt "DistinguishedName")
$profilepath = (Read-Host -Prompt "Job Title")
$homedrive = (Read-Host -Prompt "Default homedrive Path")
$scriptpath = (Read-Host -Prompt "Default logon Script")
$jobtitle = (Read-Host -Prompt "Job Title")
$department = (Read-Host -Prompt "Department")
$manager = (Read-Host -Prompt "Manager (i.e. Jdoe)")


#Script print out
Write-host "***************************************************************" Out-File -filepath C:\C:\Users\cmorris\Desktop\File out put\New user.ps1
wrtie-host "Building New Script" Out-File -filepath C:\C:\Users\cmorris\Desktop\File out put\New user.ps1
Write-host "***************************************************************" Out-File -filepath C:\C:\Users\cmorris\Desktop\File out put\New user.ps1

Write-host "***************************************************************"
wrtie-host "New Script Built"
Write-host "***************************************************************"

Out-File -filepath C:\C:\Users\cmorris\Desktop\File out put\New user.ps1

Write-host "***************************************************************"
wrtie-host "Building New Script"
Write-host "***************************************************************"

Write-host "***************************************************************"
wrtie-host "New Script Built"
Write-host "***************************************************************"

Out-File -filepath C:\C:\Users\cmorris\Desktop\File out put\Copyuser.ps1

Write-host "***************************************************************"
wrtie-host "Building New Termination Script"
Write-host "***************************************************************"

Write-host "***************************************************************"
wrtie-host "New Script Termination Built"
Write-host "***************************************************************"

Out-File -filepath C:\C:\Users\cmorris\Desktop\File out put\Termuser.ps1
