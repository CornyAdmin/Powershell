$colObj = @()
$FileName = ".\ServerResults.csv"
$ServerLists = ".\ServerLists.csv"

$Servers = import-csv $ServerLists
$ServiceName = "Spooler"

foreach ($Server in $Servers)
  {
    $SRV = $Server.name
    $SRV
    $ServiceReport = Get-Service -ComputerName $SRV -Name $ServiceName | select -property name,status,starttype
    $Service = Get-Service -ComputerName $SRV -Name $ServiceName
    $ServStatusOld = $ServiceReport.status
    $ServStartupOld = $ServiceReport.starttype
    $ServiceReport.status
    
    If ($ServiceReport.status -eq "Running")
      {
        $Service.Stop()
        Start-Sleep -Seconds 5        
      }

    If ($ServiceReport.starttype -ne "Disabled")
      {
        Set-Service -ComputerName $SRV -Name $ServiceName -StartupType Disabled
      }
    
    $ServiceUpdate = Get-Service -ComputerName $SRV -Name $ServiceName | select -property name,status,starttype
    $ServStatusNew = $ServiceUpdate.status
    $ServStartupNew = $ServiceUpdate.starttype
    $obj = New-Object System.Object
    $obj | Add-Member -type NoteProperty -name ServerName -Value $SRV
    $obj | Add-Member -type NoteProperty -name "Old Status" -Value $ServStatusOld
    $obj | Add-Member -type NoteProperty -name "Old StartType" -Value $ServStartupOld
    $obj | Add-Member -type NoteProperty -name "New Status" -Value $ServStatusNew
    $obj | Add-Member -type NoteProperty -name "New StartType" -Value $ServStartupNew
    $colObj += $obj
  }

$colObj | export-csv $FileName -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue