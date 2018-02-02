<#$MsgIntro = @#>

    write-host ***********************                               ***********************
    write-host                          Software Uninstaller Tool      Made by PRIDEVisions
    write-host ***********************                               ***********************

    <#@#>

    write-host -ForegroundColor Magenta "$MsgIntro"
    Write-host -ForegroundColor Magenta "Please select the software you wish to uninstall..."

    Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | select Displayname, InstallLocation, UninstallString | sort | Out-GridView -PassThru -OutVariable software

    write-host -ForegroundColor Yellow "The following software will be uninstalled:"

    foreach ($application in $software) {
        write-host "$Application"
        $uninstall = $Application.UnInstallString
        cmd /c $uninstall /quiet /norestart
        }


