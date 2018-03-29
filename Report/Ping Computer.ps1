﻿$Computernames = Get-ADcomputer -Filter * | Select Name

$PCData = foreach ($PC in $ComputerName) {
    Write-Verbose "Checking computer'$PC'"
    try {
        Test-Connection -ComputerName $PC -Count 2 -ErrorAction Stop | Out-Null
        $OS    = Get-WmiObject -ComputerName $PC -Class Win32_OperatingSystem -EA 0
        $Mfg   = Get-WmiObject -ComputerName $PC -Class Win32_ComputerSystem -EA 0
        $IPs   = @()
        $MACs  = @()
        foreach ($IPAddress in ((Get-WmiObject -ComputerName $PC -Class "Win32_NetworkAdapterConfiguration" -EA 0 | 
            Where { $_.IpEnabled -Match "True" }).IPAddress | where { $_ -match "\." })) {
                $IPs  += $IPAddress
                $MACs += (Get-WmiObject -ComputerName $PC -Class "Win32_NetworkAdapterConfiguration" -EA 0 | 
                    Where { $_.IPAddress -eq $IPAddress }).MACAddress
        }
        $Props = @{
            ComputerName   = $PC
            Status         = 'Online'
            IPAddress      = $IPs -join ', '
            MACAddress     = $MACs -join ', '
            DateBuilt      = ([WMI]'').ConvertToDateTime($OS.InstallDate)
            OSVersion      = $OS.Version
            OSCaption      = $OS.Caption
            OSArchitecture = $OS.OSArchitecture
            Model          = $Mfg.model
            Manufacturer   = $Mfg.Manufacturer
            VM             = $(if ($Mfg.Manufacturer -match 'vmware' -or $Mfg.Manufacturer -match 'microsoft') { $true } else { $false })
            LastBootTime   = ([WMI]'').ConvertToDateTime($OS.LastBootUpTime)
        }
        New-Object -TypeName PSObject -Property $Props
    } catch { # either ping failed or access denied 
        try {
            Test-Connection -ComputerName $PC -Count 2 -ErrorAction Stop | Out-Null
            $Props = @{
                ComputerName   = $PC
                Status         = $(if ($Error[0].Exception -match 'Access is denied') { 'Access is denied' } else { $Error[0].Exception })
                IPAddress      = ''
                MACAddress     = ''
                DateBuilt      = ''
                OSVersion      = ''
                OSCaption      = ''
                OSArchitecture = ''
                Model          = ''
                Manufacturer   = ''
                VM             = ''
                LastBootTime   = ''
            }
            New-Object -TypeName PSObject -Property $Props            
        } catch {
            $Props = @{
                ComputerName   = $PC
                Status         = 'No response to ping'
                IPAddress      = ''
                MACAddress     = ''
                DateBuilt      = ''
                OSVersion      = ''
                OSCaption      = ''
                OSArchitecture = ''
                Model          = ''
                Manufacturer   = ''
                VM             = ''
                LastBootTime   = ''
            }
            New-Object -TypeName PSObject -Property $Props              
        }
    }
}
$PCData | sort ComputerName |
    select ComputerName, Status, OSVersion, OSCaption, OSArchitecture, IPAddress, MacAddress, VM, Model, Manufacturer, DateBuilt, LastBootTime