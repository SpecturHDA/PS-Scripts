Write-Host "*********************************************" -ForegroundColor Green
Write-Host "Importing AD and Exchange Modules" -ForegroundColor Yellow 
Write-Host "*********************************************" -ForegroundColor Green
import-module activedirectory
Write-Host "Import Complete!" -ForegroundColor Yellow 
Write-Host "*********************************************" -ForegroundColor Green

#Prompt for username
$firstname = Read-Host -Prompt 'Enter the First Name (i.e. Jdoe)'
$lastname = Read-Host -Prompt 'Enter the Last Name (i.e. Jdoe)'
$Fullname = $firstname + " " + $lastname
$Displayname = $Fullname
$Name = @(Get-aduser -Filter {DisplayName -like $Displayname} | select -ExpandProperty SamAccountName)
if ($Name.Count -gt 1) {
    1..($Name.Count) | ForEach-Object {
            Write-Host("$_. " + $Name[$_ -1 ].ToString())
        }
    Write-host "`r`n"
    while(1) { # Loop until a valid selection is made
        $selection = Read-Host -Prompt "Please Select the Login you wish to Disable (i.e. 1 or 5)"
        try { [int]::TryParse($selection,[ref]$selection) | Out-Null } catch { }
        if ( ($selection -is [int]) -and ($selection -gt 0)) {
            $SamAccountName = $Name[$selection - 1]
            if ( -not ([string]::IsNullOrWhiteSpace($SamAccountName)) ) {
                break
            }
        }
    }

    Write-Host "User selected: $SamAccountName"

} elseif ($Name.Count -eq 1) {
    $SamAccountName = $Name
    Write-Host "One user found: $SamAccountName"
} else {
    Write-Host "No users found"
}

#Disable account in AD
Write-Host "Disabling AD Account for '$SamAccountName'" -ForegroundColor Yellow
Write-Host "*********************************************" -ForegroundColor Green
Disable-ADAccount -Identity $SamAccountName
Write-Host "Done!" -ForegroundColor Yellow
Write-Host "*********************************************" -ForegroundColor Green

#Document existing AD groups in CW ticket, then remove user from all groups except domain users.
Write-Host "Please document the below group memberships for '$Fullname' below" -ForegroundColor Yellow
Get-ADPrincipalGroupMembership –identity $SamAccountName | Select-Object name
Write-Host "*********************************************" -ForegroundColor Green

#Move user to “Disabled>>>Active Mailbox” OU
Write-Host "*********************************************"
Write-Host "Moving AD User '$username' to OU: Disabled\Active Mailbox" -ForegroundColor Yellow -BackgroundColor DarkGreen
Write-Host "*********************************************"
Get-ADUser $username | Move-ADObject -TargetPath 'OU= ,OU=,DC=,DC='
Write-Host "Done!"
Write-Host "*********************************************"




