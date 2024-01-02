$ServerLists = ".\ServerLists.csv"

$Servers = import-csv $ServerLists

foreach ($Server in $Servers)
  {
    $SRV = $Server.name
    $SRV
    $Service = Get-Service -ComputerName $SRV -Name Spooler
    
    
    If ($Service.status -eq "Running")
      {
        $Service.status
        $Service.Stop()
        Start-Sleep -Seconds 5
        
      }
      
    Set-Service -ComputerName $SRV -Name Spooler -StartupType Disabled
       
  }