$secureStringPwd = Read-Host -AsSecureString
$secureStringText = $secureStringPwd | ConvertFrom-SecureString 
Set-Content ".\LaunchCodes.txt" $secureStringText