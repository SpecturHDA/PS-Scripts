Send email from Powershell


[xml]$config = Get-Content ".\config.xml"
$file = "C:\folder\file.csv"
$Attachment = new-object Net.Mail.Attachment($file)
Send-MailMessage -From "User01 <user01@example.com>" -To "User02 <user02@example.com>", "User03 <user03@example.com>" -Subject "Sending the Attachment" -Body "Forgot to send the attachment. Sending now." -Attachments "data.csv" -Priority High -dno onSuccess, onFailure -SmtpServer "smtp.fabrikam.com"
 
# Use read credentials
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "example.com"
    UserName = $config.Configuration.UserName
    Password = $config.Configuration.Password
}

Send-MailMessage `
    -To 'cmorris@centrexit.com' `
    -Subject 'Test' `
    -Body "Hello test,

This is an email test for sending emails with attachments. 
$msg.Attachments.Add($Attachment)

Please feel free to call or email if you have any questions. Thank you!

Chris Morris | Support Analyst| cmorris@centrexIT.com | centrexIT.com |   
Help Desk: 619.651.8787 | Fax: 619.651.8701" `
    -UseSsl `
    -Port '587' `
    -SmtpServer 'smtp.office365.com' `
    -From 'cmorris@mrcmit.com' `
    -Credential $UserCredential


    