#-join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
$PW = -join(((65..90)+(33..64)+(97..122) | % {[char]$_})+(0..9) | Get-Random -Count 16)
$PW