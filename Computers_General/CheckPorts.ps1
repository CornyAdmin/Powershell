$colObj = @()
$Filename = ".\Computers.csv"
$Exports = ".\PortResults.csv"
$EndPoint = "<IP>"
$Port = "<port>"

$DCs = import-csv $Filename

Foreach($DC in $DCs)
    {
      $DCName = $DC.ComputerName
      $s = New-PSSession -ComputerName $DCName
      Enter-PSSession -Session $s
      Invoke-Command -Session $s -ScriptBlock {$EndPoint = "<IP>"}
      $Result = Invoke-Command -Session $s -ScriptBlock {Test-netConnection -computername $EndPoint -port "<port>" | Select SourceAddress,ComputerName,TcpTestSucceeded}
      Exit-PSSession
      $Obj = New-Object PSObject
      $Obj | Add-Member NoteProperty -Name DC_Name -Value $DCName
      $Obj | Add-Member NoteProperty -Name IP -Value $Result.SourceAddress.IPAddress
      $Obj | Add-Member NoteProperty -Name EndPoint -Value $Result.ComputerName
      $Obj | Add-Member NoteProperty -Name Result -Value $Result.TcpTestSucceeded
      $ColObj += $obj
      
    }

$ColObj | export-Csv $Exports -Encoding "unicode" -NoTypeInformation -Delimiter "`t" -ErrorAction SilentlyContinue


#$a = 1
#$b = 2
# with the $using scope modifier 
#Invoke-Command -ComputerName $server `
#               -ScriptBlock {"Sum:{0}" -f $($using:a+$using:b)} `
#               -Credential $creds