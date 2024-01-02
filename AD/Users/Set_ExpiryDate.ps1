$Records = Import-Csv '.\expiration.csv'

Foreach ($Record in $Records)
  {
    Set-ADUser -Identity $Record.sAMAccountName -AccountExpirationDate $Record.New_Expiry
  }
    
    
    	
