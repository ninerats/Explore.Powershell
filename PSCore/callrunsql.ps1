Import-Module -Verbose $PSScriptRoot\Core.psm1
Import-Module  -Verbose  "$PSScriptRoot\database.psm1"

#Invoke-SQL "(localdb)\v11.0" AdventureWorks2012 "SELECT COUNT (*) FROM Person.Address"
#Run-SQL "(localdb)\v11.0" AdventureWorks2012 "BACKUP DATABASE [AdventureWorks2012] TO  DISK = N'D:\SqlData\Avworks.bak' WITH NOFORMAT, INIT,  NAME = N'AdventureWorks2012-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10"
Backup-Database "(localdb)\v11.0" AdventureWorks2012 "D:\SqlData\Avworks2.bak"
