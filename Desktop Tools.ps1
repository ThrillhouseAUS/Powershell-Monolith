#Welcome to SD Tools, the premuim in crappy self made job efficiency programs.
#Feel free to add your own stuff or just leave it as is, I can't tell you what to do as I am just a text comment.
#Created by: Harry Goodwin for use in the TRANSURBAN prod environment
#Project start date: 28/06/2020 AEST

#GUI Build.

Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='SD Tools'
$main_form.Width = 600
$main_form.Height = 400
$main_form.AutoSize = $true

$resetpassb = New-Object System.Windows.Forms.Button
$resetpassb.Location = New-Object System.Drawing.Size(400,10)
$resetpassb.Size = New-Object System.Drawing.Size(120,23)
$resetpassb.Text = "Password Reset"
$main_form.Controls.Add($resetpassb)

$uinfo = New-Object System.Windows.Forms.Button
$uinfo.Location = New-Object System.Drawing.Size(400,40)
$uinfo.Size = New-Object System.Drawing.Size(120,23)
$uinfo.Text = "Get User Info"
$main_form.Controls.Add($uinfo)

$exportG = New-Object System.Windows.Forms.Button
$exportG.Location = New-Object System.Drawing.Size(400,70)
$exportG.Size = New-Object System.Drawing.Size(120,23)
$exportG.Text = "Export Groups"
$main_form.Controls.Add($exportG)

$Label3 = New-Object System.Windows.Forms.Label
$Label3.Text = ""
$Label3.Location  = New-Object System.Drawing.Point(110,40)
$Label3.AutoSize = $true
$main_form.Controls.Add($Label3)

$ErrorSoE = New-Object System.Windows.Forms.Button
$ErrorSoE.Location = New-Object System.Drawing.Size(400,100)
$ErrorSoE.Size = New-Object System.Drawing.Size(120,23)
$ErrorSoE.Text = "Error 708"
$main_form.Controls.Add($ErrorSoE)

$WMSInstall = New-Object System.Windows.Forms.Button
$WMSInstall.Location = New-Object System.Drawing.Size(400,130)
$WMSInstall.Size = New-Object System.Drawing.Size(120,23)
$WMSInstall.Text = "WMS Install"
$main_form.Controls.Add($WMSInstall)

#Function 1 Export Groups, this will export all of a users groups to a txt file in your temp folder.
$exportG.Add_Click(
{
# Input Box 
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') 
$samname = [Microsoft.VisualBasic.Interaction]::InputBox("Enter an username or computername$", "Get AD Group Membership", "") 
# Get-ADPrincipalGroupMembership with specified username and export it to c:\samaccountname.csv 
Get-ADPrincipalGroupMembership $samname | select name | export-csv "D:\$samname.csv" 
Label3.Text = "Done, go to D:\ for results" 
}
)



#Function 2 Gives you a users info for troubleshooting, it's a good way to find out if their account is disabled too :) 
$uinfo.Add_Click(
{
# Input Box 
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') 
$uname = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a username$", "Get AD user details", "") 
#Get-ADUser with specified username to see data.
$Label3.Text = Get-ADUser $uname
#Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} â€“Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" |
#Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
}
)



#Function 3 I reset the users password to a simplified format after some checks for example if the date is monday the 4th then the password will set to Monday04 
$resetpassb.Add_Click(
{
$resetpass = Get-Date -Format "dddd"
$resetpass += Get-Date -Format "dd"
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') 
$uname = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a username$", "Get AD user details", "") 
Set-ADAccountPassword -Identity $uname -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$resetpass" -Force)
Label3.Text = "Password reset to" + $resetpass
}
)

#Function 4 Run for error 708 on adobe install 
$ErrSoE.Add_Click(
{
    Set-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "Security_HKLM_only" -Type DWord -Value 0
}
)

$WMSInstall.Add_Click(
{
    cd \\ns1srap19\source$\Apps\IBM\Downloads\
    ./vcredist_x64.EXE | Out-Null
    Remove-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "PendingFileRenameOperations" 
    cd \\ns1srap19\source$\Apps\IBM\Manhattan_2016_x64\
    ./setup.exe | Out-Null
    Remove-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "PendingFileRenameOperations"
    cd \\ns1srap19\source$\Apps\IBM\Downloads
    ./SI67278_64a.exe | Out-Null
    Remove-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "PendingFileRenameOperations"
    cd C:\Users\Public\Documents\IBM\Client Access\
    REN "C:\Users\Public\Documents\IBM\Client Access\cwbssldf.kdb" cwbssldf.kdb.old
    cd \\ns1srap19\source$\Apps\IBM\Manhattan_2016_Custom_Settings
    Xcopy "cwbssldf.kdb" "C:\Users\Public\Documents\IBM\Client Access\" /q /y
    Xcopy "2016 PROD Manhattan.ws" "C:\Users\Public\Desktop\" /q /y

}
)


$main_form.ShowDialog()
