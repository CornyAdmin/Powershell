param(
		[Parameter(Mandatory, Position=0, ParameterSetName="encFile")][string]$encFile,
        [Parameter(Mandatory, Position=0, ParameterSetName="encString")][string]$encString,
		[Parameter(Mandatory = $True)][string]$Path
	)

if ($psCmdlet.ParameterSetName -eq "encFile") {
		$encoded = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes((Get-Content -Path $encFile -Raw -Encoding UTF8)))
        $encoded = ([regex]::Matches($encoded,'.','RightToLeft') | ForEach {$_.value}) -join ''
		}

elseif ($psCmdlet.ParameterSetName -eq "encString") {
		$encoded = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($encString))
        $encoded = ([regex]::Matches($encoded,'.','RightToLeft') | ForEach {$_.value}) -join ''
		}

$encoded = "`r`n" + $encoded
$encoded | Out-File -FilePath $Env:USERPROFILE\Desktop\load.txt
cmd.exe /c copy /b "$Path" + "$Env:USERPROFILE\Desktop\load.txt" "$Path"
rm $Env:USERPROFILE\Desktop\load.txt -r -Force -ErrorAction SilentlyContinue
