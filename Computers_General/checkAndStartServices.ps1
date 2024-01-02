$Lists = ".\ComputerList.csv"

$Servers = import-csv $Lists

foreach ($Server in $Servers)
  {
    $DC = $Server.name
    $Service = Get-Service -ComputerName $DC -Name "<ServiceName>"
    $Server
    
    If ($Service.status -eq "Stopped")
      {
        $Service.status
        $Service.Start()
      }
      
    If ($Service.status -eq "Running")
      {
        $Service.status
        $Service.Stop()
        Start-Sleep -Seconds 20
        $Service.Start()
      }
       
  }