### Ask for credentials
 
$username = Read-Host "Enter Email Address" -AsSecureString

$password = Read-Host "Enter password of $username" -AsSecureString
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $password
$subject = 'Please Whitelist My Mac'
$body = ipconfig /all | Out-String
 
### Splatting with Hash Table
 
$hash = @{
 
To = 'desktopsupport@api.net.au'
From = $username
Subject = $subject
Body = $body
BodyAsHtml = $true
SmtpServer = 'smtp.office365.com'
UseSSL = $true
Credential = $cred
Port = 25
 
}
 
### Send Mail
 
Send-MailMessage @hash -WarningAction Ignore