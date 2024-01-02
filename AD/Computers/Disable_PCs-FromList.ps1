import-module activedirectory
#$ErrorActionPreference = "silentlycontinue"
$colObj = @()
$coldisobj = @()
$Collection = @()
$errcontentDis = ""

$CurrentDate = Get-Date -UFormat "%Y-%m-%d"
$CurrentDate = $CurrentDate.ToString()
$FileName = ".\DisableResults_" + $CurrentDate + ".csv"

$PCs = cat '.\Disable.txt'

foreach ($PC in $PCs)
	{
		$disobj = New-Object System.Object

				$pc
				$Disabled = "True"
				get-adcomputer $pc -ErrorVariable errDis -ErrorAction SilentlyContinue
				$errcontentDis = $errDis | Select-String -pattern "Cannot find an object with identity" -quiet
				If ($errcontentDis -and $errDis)
					{
						$Disabled = "Error finding object"
					}
					Else
						{
							$pcSettings = get-adcomputer $pc -Properties ProtectedFromAccidentalDeletion
							If ($pcSettings.ProtectedFromAccidentalDeletion) {Set-ADObject $pcSettings -ProtectedFromAccidentalDeletion:$False}
							get-adcomputer $pc | disable-adaccount

						}
				$disobj | Add-Member -type NoteProperty -name Name -Value $pc
				$disobj | Add-Member -type NoteProperty -name disableStatus -Value $Disabled
				$err = $null
				$errcontent = $null
				$coldisobj += $disobj

	}

$coldisobj | export-csv $FileName -Encoding "unicode" -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue