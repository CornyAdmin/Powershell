param(
		[Parameter(Mandatory, Position=0, ParameterSetName="decFile")][string]$decFile,
        [Parameter(Mandatory, Position=0, ParameterSetName="decString")][string]$decString,
		[Parameter(Mandatory = $False)][string]$Path
	)

if ($psCmdlet.ParameterSetName -eq "decFile") {
		$contents = Get-Content $decFile
		foreach ($line in $contents) {
			$LineCount++
		}
		foreach ($line in $contents) {
			$Lines++
			If ($Lines -eq $LineCount) {
				$content = $line
			}
		}
		$content
		$decoded = ([regex]::Matches($content,'.','RightToLeft') | ForEach {$_.value}) -join ''
		$decoded = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($decoded))
        }

elseif ($psCmdlet.ParameterSetName -eq "decString") {		
		$decoded = ([regex]::Matches($decString,'.','RightToLeft') | ForEach {$_.value}) -join ''
		$decoded = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($decoded))
        }

$decoded = $decoded -replace '\0'
Write-Host $decoded
If ($Path) {
		$decoded | Out-File -FilePath $Path
	}
