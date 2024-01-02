import-module activedirectory

$Computers = import-csv .\ServerList.csv

foreach ($Computer in $Computers)
	{
    $Server = $Computer.Name
    $Path = $Computer.OU
    $Server
    $Path
		New-ADComputer -Name $Server -SamAccountName $Server -Path $Path -Enabled $True
	}