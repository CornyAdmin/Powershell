import-module activedirectory
#$ErrorActionPreference = "silentlycontinue"
$colObj = @()
$coldisobj = @()
$Collection = @()

$CurrentDate = Get-Date -UFormat "%Y-%m-%d"
$CurrentDate = $CurrentDate.ToString()
$FileName = "D:\Scripts\Workstation_Management\DisableResults_ZA_" + $CurrentDate + ".csv"

$smtpServer = "<SMTPServer>"
$fromAddress = "<Sender>"
$toAddress = "<Recipients>" # Comma delimiter for multple addresses
$ubject = "Computers Disabled in AD"

$OUs = cat '.\OrgOUs.txt'
$root = (Get-ADDomain).DistinguishedName
$DisOU = "ou=Disabled Computers,"
$DisOUFil = "*,ou=Disabled Computers,*"

ForEach ($OU in $OUs)
	{
		$OUSearch = $OU + $root
		$OULevels = Get-ADOrganizationalUnit -Filter * -SearchScope subtree -SearchBase $OUSearch | select DistinguishedName
		ForEach ($OULevel in $OULevels)
			{

				$d = [DateTime]::Today.AddDays(-45)
				$Extract = Get-ADComputer -SearchScope oneLevel -SearchBase $OULevel.DistinguishedName -properties name,pwdLastSet,PasswordLastSet,lastLogonTimeStamp,Enabled,servicePrincipalName,DistinguishedName -Filter {((PasswordLastSet -le $d) -or (PasswordLastSet -notlike "*")) -and ((lastLogonTimeStamp -notlike "*") -or (lastLogonTimeStamp -le $d)) -and (servicePrincipalName -notlike "*MSClusterVirtualServer*")} | 
				#$Extract = Get-ADComputer1 -SearchScope oneLevel -SearchBase $OULevel.DistinguishedName -properties name,pwdLastSet,PasswordLastSet,lastLogonTimeStamp,Enabled,servicePrincipalName,DistinguishedName -Filter {((lastLogonTimeStamp -notlike "*") -or (lastLogonTimeStamp -le $d)) -and (servicePrincipalName -notlike "*MSClusterVirtualServer*")} | 
				Where {$_.DistinguishedName -notlike $DisOUFil} | 
				select name,
				PasswordLastSet,
				@{Name="pwdLastSet"; Expression={[DateTime]::FromFileTime($_.pwdLastSet)}},
				@{Name="lastLogonTimeStamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}},
				Enabled,DistinguishedName
				$Collection += $Extract
			}
	}


$olds = $Collection

foreach ($old in $olds)
	{
		$obj = New-Object System.Object
        $comp = $old.name
        $compdn = $old.DistinguishedName
        $obj | Add-Member -type NoteProperty -name Name -Value $comp
        $obj | Add-Member -type NoteProperty -name DistinguishedName -Value $compdn
		$pings = ping $old.name
		$result = $pings | Select-String "could not find host" -quiet
		If ($result -eq "true") {$offline = "True"}
		else {$offline = "False"}
		$obj | Add-Member -type NoteProperty -name offlineStatus -Value $offline
		$colObj += $obj
	}

$Disables = $colObj

foreach ($Disable in $Disables)
	{
		$disobj = New-Object System.Object
		$disResult = $Disable.offlineStatus
		If ($disResult -eq "True") 
			{
				$pc = $Disable.DistinguishedName
				$pcName = $Disable.Name
				$Disabled = "True"
				$Moved = "True"
				get-adcomputer $pc -ErrorVariable errDis -ErrorAction SilentlyContinue | disable-adaccount 
				$errcontentDis = $errDis | Select-String -pattern "Cannot find an object with identity" -quiet
				If ($errcontentDis -and $errDis)
					{
						$Moved = "Error finding object"
						$Disabled = "Error finding object"
					}
					Else
						{
							$pcSettings = get-adcomputer $pc -Properties ProtectedFromAccidentalDeletion
							If ($pcSettings.ProtectedFromAccidentalDeletion -eq "True") {Set-ADObject $pcSettings -ProtectedFromAccidentalDeletion:$False}
							Set-ADcomputer $pc -replace @{extensionAttribute8=$CurrentDate}
							$pcDN = Get-ADComputer $pc | select DistinguishedName
							ForEach ($OU in $OUs)
								{
									$DisTargetPath = $DisOU + $OU + $root
									$pathCheck = $OU + $root
									Write-Host $DisTargetPath
									Write-Host $pcDN.DistinguishedName
									Write-Host $pathCheck
									If ($pcDN.DistinguishedName -match $pathCheck -and -not($pcDN.DistinguishedName -match $DisTargetPath)) 
										{
											Write-Host "Match Found."
											Set-ADcomputer $pc -add @{extensionattribute9=$pcDN.DistinguishedName}
                                           
											get-adcomputer $pc | Move-ADObject -TargetPath $DisTargetPath -ErrorVariable errMove -ErrorAction SilentlyContinue
											$errcontentMove = $errMove | Select-String -pattern "Access is denied" -quiet 
											If ($errcontentMove -and $errMove) {$Moved = "Access is denied"}
											elseif (-Not($errcontentMove) -and $errMove) {$Moved = "Error moving computer"}
										}
								}
						}
				$disobj | Add-Member -type NoteProperty -name Name -Value $pcName
				$disobj | Add-Member -type NoteProperty -name disableStatus -Value $Disabled
				$disobj | Add-Member -type NoteProperty -name MoveStatus -Value $Moved
                
                #sorry Nic here , I need the DN :)
                Try
                {
                   $disobj | Add-Member -NotePropertyName "DisabledDate" -NotePropertyValue $CurrentDate
                   $disobj | Add-Member -NotePropertyName "DN" -NotePropertyValue $pcDN.DistinguishedName -ErrorAction SilentlyContinue
                                   }
                Catch{}
                #Thanks for understanding - Nic! :) #

				$err = $null
				$errcontent = $null
				$coldisobj += $disobj
			}
	}

$coldisobj | select name,DisableStatus,moveStatus | export-csv $FileName -Encoding "unicode" -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue
Send-MailMessage -From $fromAddress -SmtpServer $smtpServer -To $toAddress -Subject $ubject -Body "Hi All, Here is a list of all disabled computers in AD." -Attachments $FileName
