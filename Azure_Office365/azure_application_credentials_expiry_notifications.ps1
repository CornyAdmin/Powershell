#Environment variables
$tenantid = "<tenantid>"
$clientid = "<clientid>"
$certificatethumbprint = "<Certthumbprint>"
$scopes = '"Directory.Read.All", "Application.Read.All"'
$defaultmailaddress = "<adminmailaddress>"
$expirywarning = 60 #Number of days
$expiryaction = 30 #Number of days
$smtpserver = "<SMTPServer>"
$fromaddress = "<Sender>"
$toaddress = "<Recipients>" # Comma delimiter for multiple addresses
$subjectwarning = "<subject>"
$subjectaction = "<subject>"
$bodywarning = "<message body>"
$bodyaction = "<message body>"
$x = 0
 
#Connect to Microsoft Graph
#Connect-MgGraph $scopes
#Connect-MgGraph -ClientId $clientid -TenantId $tenantid -CertificateThumbprint $certificatethumbprint
 
#Set variables
$ColObj = @()
$CurrentDate = Get-Date -UFormat "%Y-%m-%d"
$warning = [DateTime]::Today.AddDays($expirywarning)
$action = [DateTime]::Today.AddDays($expiryaction)
 
$AllApps = Get-MgApplication -All -Property $Properties | Select-Object $Properties
 
Foreach ($AllApp in $AllApps) {
    $Obj = New-Object PSObject
    Write-Host "Application Name:" $AllApp.DisplayName
    $AppCreds = $AllApp.PasswordCredentials
    $CertCreds = $AllApp.KeyCredentials
    $Owners = (Get-MgApplicationOwner -All -ApplicationId $AllApp.Id | Select AdditionalProperties -ExpandProperty AdditionalProperties).mail
    If ($Owners) {
        If ($Owners.count -eq 1) {
            $toaddress = $Owners
        } else {
            Foreach ($Owner in $owners) {
                $x++
                If ($x -lt $Owners.count) {
                    $toaddress += $Owner
                    $toaddress += ","
                } else {
                    $toaddress += $Owner
                }
            }
        }
        $x = 0
    } else {
        $toaddress = $defaultmailaddress
    }
    Write-Host "Mail to:" $toaddress
    If ($AppCreds) {
        Foreach ($AppCred in $AppCreds) {
            $AppCredDisplayName = $AppCred.DisplayName
            $AppCredEndDateTime = $AppCred.EndDateTime
            If (($AppCredEndDateTime -le $warning) -and ($CertCredEndDateTime -gt $action)) {
                #Send-MailMessage -From $fromAddress -SmtpServer $smtpServer -To $toAddress -Subject $subjectwarning -Body $bodywarning
                Write-Host "WARNING:Do Something" $AppCredEndDateTime
            }
            If ($AppCredEndDateTime -le $action) {
                #Send-MailMessage -From $fromAddress -SmtpServer $smtpServer -To $toAddress -Subject $subjectaction -Body $bodyaction
                Write-Host "ACTION:Do Something" $AppCredEndDateTime
            }
            $AppCredKeyId = $AppCred.KeyId
        }
    }
    If ($CertCreds) {
        Foreach ($CertCred in $CertCreds) {
            $CertCredDisplayName = $CertCred.DisplayName
            $CertCredEndDateTime = $CertCred.EndDateTime
            If (($CertCredEndDateTime -le $warning) -and ($CertCredEndDateTime -gt $action)) {
                #Send-MailMessage -From $fromAddress -SmtpServer $smtpServer -To $toAddress -Subject $subjectwarning -Body $bodywarning
                Write-Host "WARNING:Do Something" $CertCredEndDateTime
            }
            If ($CertCredEndDateTime -le $action) {
                #Send-MailMessage -From $fromAddress -SmtpServer $smtpServer -To $toAddress -Subject $subjectaction -Body $bodyaction
                Write-Host "ACTION:Do Something" $CertCredEndDateTime
            }
            $CertCredKeyId = $CertCred.KeyId
        }
    }
    $toaddress = ''
}
 
#Disconnect-MgGraph