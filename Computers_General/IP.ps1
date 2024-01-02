Import-Module azureadpreview
$username = "<ServiceAccount>"
$pwdTxt = Get-Content ".\LaunchCodes.txt"
$securePwd = $pwdTxt | ConvertTo-SecureString 
$credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePwd
Connect-AzureAD -credential $credObject