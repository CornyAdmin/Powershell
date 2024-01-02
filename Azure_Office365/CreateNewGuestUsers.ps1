$colObj = @()
$x = 0
$CurrentDate = Get-Date -UFormat "%Y-%m-%d"
$OldDate = [DateTime]::Today.AddDays(-7).ToString("yyyy-MM-dd")
$CurrentDate
$OldDate

$smtpServer = "<SMTPServer>"
$fromAddress = "<Sender>"
$toAddress = "<Recipient1>","<Recipient2>"
$ubject = "New users added to tenant"

$CurrentFile = ".\.AD_Sync_" + $CurrentDate + ".csv"
$PreviousFile = ".\.AD_Sync_" + $OldDate + ".csv"

Copy-Item "<SharedFile>" -Destination "."
Rename-Item -Path ".\.AD_Sync.csv" -NewName $CurrentFile

$Currents = import-csv $CurrentFile
$OldAccs = import-csv $PreviousFile

$Output = ".\ToImport-" + $CurrentDate + ".csv"
$Mail = ".\NewUsers-" + $CurrentDate + ".csv"

#Compare Employee list. Only new accounts will be created.
foreach ($Current in $Currents)
    {
        $CurUser = $Current.username
        $x = 0    
        foreach ($oldAcc in $oldAccs)
                {
                    $oldUser = $oldAcc.username
                    
                    If ($CurUser -eq $oldUser)
                        {
                            #Write-Host "Match Found"
                            #$oldUser
                            $x = 1
                        }
                  
                }
        If ($x -eq 0)
                {
                    $Name = $Current.FNAME + " " + $Current.LNAME

                    $obj = New-Object System.Object
                    $obj | Add-Member -type NoteProperty -name UserName -Value $CurUser
                    $obj | Add-Member -type NoteProperty -name FName -Value $Current.FNAME
                    $obj | Add-Member -type NoteProperty -name LName -Value $Current.LNAME
                    $obj | Add-Member -type NoteProperty -name Email -Value $Current.EMAIL
                    $obj | Add-Member -type NoteProperty -name Name -Value $Name
                    $colObj += $obj

                }

    }

$colObj | export-csv $Output -Encoding "unicode" -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue
$colObj | Select FNAME,LNAME | export-csv $Mail -Encoding "unicode" -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue
$NewUsers = $colObj | Measure-Object
$Counter = $NewUsers.Count



If ($Counter -eq 0) {
    
    Write-Host "No new users to be create"
    $NoUsers = @"
    <html>
        <body style="font-family:calibri"> 
    <p>Hi,<br>
    <br>
    No new Guest accounts will be created on the tenant.<br>
    <br>
    Kind Regards.</p>
    </body>
    </html>
"@

    Send-MailMessage -From $fromAddress -SmtpServer $smtpServer -To $toAddress -Subject $ubject -BodyAsHtml -Body $NoUsers
    
  } else {
    
    Write-Host "Creating " $NewUsers.Count " new users..."
  
    Import-Module azureadpreview
    $username = "<ServiceAccount>"
    $pwdTxt = Get-Content ".\EncodedFile.txt"
    $securePwd = $pwdTxt | ConvertTo-SecureString 
    $credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePwd
    Connect-AzureAD -credential $credObject
    $Guests = import-csv $Output -Delimiter "`t"

    #Create Guest Accounts
    Foreach ($Guest in $Guests) 
      {
        $GuestName = $Guest.Name
        $Guestmail = $Guest.Email
        New-AzureADMSInvitation -InvitedUserDisplayName $GuestName -InvitedUserEmailAddress $Guestmail -InviteRedirectURL https://myapps.microsoft.com -SendInvitationMessage $false
      }

    #Add FirstName and LastName to the Guest Accounts
    Foreach ($Guest in $Guests) 
      {
        $GuestName = $Guest.Name
        $Guestmail = $Guest.Email
        $Guestmail = $Guestmail.Insert(0,"'")
        $Guestmail += "'"
        $GuestFName = $Guest.FNAME
        $GuestLName = $Guest.LNAME
        Get-AzureADUser -Filter "Mail eq $Guestmail" | Set-AzureADUser -Surname $GuestLName -GivenName $GuestFName
      }

    Start-Sleep -Seconds 20

    #Add Guest Accounts to "GroupName" in Azure
    #groupID - "<ObjectID>" (DisplayName: GroupName)
    foreach ($Guest in $Guests) 
      {
        $Guestmail = $Guest.email
        $Guestmail = $Guestmail.Insert(0,"'")
        $Guestmail += "'"
        $GuestIDDetails = Get-AzureADUser -Filter "Mail eq $Guestmail" | Select ObjectId
        $GuestID = $GuestIDDetails.ObjectId
        Add-AzureADGroupMember -ObjectId '<ObjectID>' -RefObjectId $GuestID
      }
    
    $NewUsers = @"
    <html>
        <body style="font-family:calibri"> 
    <p>Hi,<br>
    <br>
    $Counter new Guest account(s) will be created on the tenant.<br>
    <br>
    See attached list of new accounts.<br>
    <br>
    Kind Regards.</p>
    </body>
    </html>
"@
        
    Send-MailMessage -From $fromAddress -SmtpServer $smtpServer -To $toAddress -Subject $ubject -BodyAsHtml -Body $NewUsers -Attachments $Mail

}

  
Move-Item $PreviousFile -Destination ".\Archive"
Move-Item $Output -Destination ".\Archive"
Del $Mail