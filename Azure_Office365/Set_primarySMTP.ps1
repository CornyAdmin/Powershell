$Mailboxes = import-Csv ".\mailboxes.csv"

foreach ($Mailbox in $Mailboxes) 
  {
       Write-Host "User Name:" $Mailbox.UserName
       $UserName = $Mailbox.UserName
       $PrimarySMTP = $Mailbox.PrimarySMTP
       $PrimarySMTP = $PrimarySMTP.Insert(0,"'")
       $PrimarySMTP += "'"
       Write-Host "Adding SMTP:" $PrimarySMTP
       #Get-RemoteMailbox $UserName | Set-RemoteMailbox -EmailAddresses @{add=$PrimarySMTP}
       #Get-RemoteMailbox $UserName | Set-RemoteMailbox -PrimarySmtpAddress $PrimarySMTP
       Get-Mailbox $UserName | Set-Mailbox -EmailAddresses @{add=$PrimarySMTP}
       Get-Mailbox $UserName | Set-Mailbox -PrimarySmtpAddress $PrimarySMTP
  }
  