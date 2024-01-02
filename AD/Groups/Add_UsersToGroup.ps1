import-module ActiveDirectory
Import-Csv .\GroupMembers.csv | foreach {Add-ADGroupMember '<GroupName>' -Members $_.username}