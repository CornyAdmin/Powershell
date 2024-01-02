$smtpServer = "<Server>"
$fromAddress = "<Sender>"
$toAddress = "<Recipient>"
$ubject = "Mail test"

Send-MailMessage -From $fromAddress -SmtpServer $smtpServer -To $toAddress -Subject $ubject -Body "Hi All, Just testing mail." -port "<port>"