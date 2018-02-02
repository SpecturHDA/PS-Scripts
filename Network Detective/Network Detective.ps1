# -----------------------------------------------------------------------
# Run Network Detective automatically.
# -----------------------------------------------------------------------
# Created by PerfectImpact
# 26/01/2018
# -----------------------------------------------------------------------
# DOWNLOAD NETWORK DETECTIVE
# -----------------------------------------------------------------------

New-Item -ItemType Directory -Path "C:\NetworkDetective" | Out-Null

$url = "https://s3.amazonaws.com/networkdetective/download/NetworkDetectiveComputerDataCollector.exe"
Invoke-WebRequest -Uri $url -OutFile "C:\NetworkDetective\NDInstall.exe"

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

[System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

Unzip "C:\NetworkDetective\NDInstall.exe" "C:\NetworkDetective"

# -----------------------------------------------------------------------
# INPUT VARIABLES:
# -----------------------------------------------------------------------
# Directory
# -----------------------------------------------------------------------

$dir = "C:\NetworkDetective"

# -----------------------------------------------------------------------
# File Name
# -----------------------------------------------------------------------

$outbase = $env:COMPUTERNAME

# -----------------------------------------------------------------------
# IP Range
# -----------------------------------------------------------------------

$exr = "-"
$where = { $_.IPSubnet -like "255.255.255.*" -and $_.Description -notlike "Hyper-V*" }

$IPRa = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $env:COMPUTERNAME | Where-Object $where | Select-Object -Property IPAddress | Format-Table -HideTableHeaders | Out-String
$IPAr = $IPRa | Convert-String -Example "{*.*.*.*}=*.*.*.*"
$Trim = $IPAr.ToString()
$IPTr = $Trim.Substring(0, $Trim.LastIndexOf('.'))
$iprange = $IPTr + ".1" + $exr + $IPTr + ".254"

# -----------------------------------------------------------------------
# Credentials
# -----------------------------------------------------------------------

Function Get-Credentials {

$url = Invoke-WebRequest -Uri "https://provision.gatenbyservices.co.uk/nd.php?machineName=$env:COMPUTERNAME" -UseBasicParsing -UseDefaultCredentials

# Get Webpage status
$script:status = $url.ToString() -split "[`r`n]" | Select-String "OK"

# Get Username & Password
$details = $url.ToString()
$line = $details -replace [Environment]::NewLine,":" -replace "OK","" | Out-String
$script:usr = $line.Split(':')[1]
$script:pwd = $line.Split(':')[2]
$script:ndt = $line.Split(':')[3]

# Print status
if ($status) {
Break
} else {
}
}

While ($true) {
if (Invoke-Expression Get-Credentials) {
} else {
Start-Sleep -Seconds 5
}
}

$scan = "-" + $ndt

# -----------------------------------------------------------------------
# NETWORK DETECTIVE PARAMETERS:
# -----------------------------------------------------------------------

$ArgumentList = "-workdir", $dir, "-outbase", $outbase, "-outdir", $dir, "-logfile", "ndfRun.log", "-ipranges", $iprange, "-net", "-creduser", $usr, "-credspwd", $pwd, "-ad", "-internet", "-speedchecks", "-eventlogs", "-dhcp", "-snmp", "public", "-snmptimeout", "10", "-externaldomains", $scan, "-silent"

# Full command list: http://support-nd.rapidfiretools.com/customer/portal/articles/1655368-network-detective-data-collector-command-line-options

# -----------------------------------------------------------------------
# RUN NETWORK DETECTIVE:
# -----------------------------------------------------------------------

Start-Process -FilePath "C:\NetworkDetective\nddc.exe" -ArgumentList $ArgumentList -WindowStyle Hidden -Wait

# -----------------------------------------------------------------------
# UPLOAD FILE
# -----------------------------------------------------------------------

$scanMsg = " Scan Complete - "
$date = Get-Date
$smtpServer = "YOUR SMTP SERVER HERE"

$file = Get-ChildItem -Path "$dir\*" -Include *.cdf, *.ndf

$att = New-Object Net.Mail.Attachment($file)
$msg = New-Object Net.Mail.MailMessage
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)

$msg.From = "YOUR FROM EMAIL"
$msg.To.Add("YOUR TO EMAIL")
$msg.Subject = $outbase.Trim(".ndf") + $scanMsg + $date
$msg.Body = "Network Detective scan complete."
$msg.Attachments.Add($att)

$smtp.Send($msg)
$att.Dispose()

# -----------------------------------------------------------------------
# REMOVE NETWORK DETECTIVE:
# -----------------------------------------------------------------------

Remove-Item C:\NetworkDetective -Recurse -Force

# -----------------------------------------------------------------------

# -----------------------------------------------------------------------