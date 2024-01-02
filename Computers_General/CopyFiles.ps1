$Lists = ".\ComputerList.csv"
$Destination = "DestinationFolderPath"
$Source = "File&Location"

$Servers = import-csv $Lists

foreach ($Server in $Servers)
  {
    $CurrentServer = $Server.name
    $CurrentServer
    $ServerPath = "\\" + $CurrentServer + $Destination
    
    Copy-Item $Source -Destination $ServerPath
    
  }