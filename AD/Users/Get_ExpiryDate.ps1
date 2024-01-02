$Records = Import-Csv '.\expiration.csv'

Foreach ($Record in $Records)
  {
    Get-ADUser -Identity $Record.sAMAccountName -Properties * | select SamAccountName,AccountExpirationDate
  }
