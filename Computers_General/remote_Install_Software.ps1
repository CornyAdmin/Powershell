$PCs = .\cat pclist.txt

ForEach ($PC in $PCs)
	{
    $Session = New-PSSession -ComputerName $pc
    $block = {msiexec /I <FileLacationAndName> /q}
    Invoke-Command -Session $Session -ScriptBlock $block
  }
  
#Get-PSSession | Remove-PSSession