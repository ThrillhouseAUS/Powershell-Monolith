Import-Module ActiveDirectory


# Input Box 
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') 
$samname = [Microsoft.VisualBasic.Interaction]::InputBox("Enter an username", "Get PC's", "") 



Import-Csv '\\ns1srap19\apps$\Asset recovery\Computers.csv' 
$csv | Select-object Details_Table0_User_Name0, Details_Table0_Name0 | Format-Table

Import-Csv '\\ns1srap19\apps$\Asset recovery\Computers.csv'  |
    Where-Object { $_.Details_Table0_User_Name0 -like $samname } |
    ForEach-Object {
        # Don't use aliases in scripts, use the real cmdlet names. Makes maintenance easier.
        Write-Host ('{7}, {8}' -f $_.Details_Table0_User_Name0,$_.Details_Table0_Name0)
    }