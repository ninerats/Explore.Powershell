#
# sandbox_common.psm1
#
########################################################################################################

$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition ## for v.2 and lower.

. $PSScriptRoot\paths.ps1

### Imports #######################################################################################################

Import-Module -Verbose $libroot\Core.psm1
Import-Module  -Verbose  "$libroot\database.psm1"

### Functions #####################################################################################################

# Assumes $sourceFolderUNC is a unc path containing backups of the LoanSphere and ODS bases, with file names 
# $dbStem.bak and $dbStem_ODS.bak
function Unpack-Databases{
	param (
		[string] $sourceFolderUNC,	
		[string] $server,
		[string] $dbStem,
		[string] $workingFolder,
		[string] $EmpowerSqlPwd,
		[string] $EmpowerUserPwd,
		[switch] $encrypted,
		[switch] $SkipBackup
	)

	$odsDbName = $dbStem + "_ODS"

	UnpackDatabase $sourceFolderUNC $server $dbStem $workingFolder $SkipBackup
	UnpackDatabase $sourceFolderUNC $server ($dbStem + "_ODS") $workingFolder $SkipBackup
	Fixup-Common $server $dbStem
}

# restores a database from a backup file.
function UnpackDatabase{
	param (
		[string] $sourceFolderUNC,	
		[string] $server,
		[string] $database,
		[string] $workingFolder,
		[switch] $SkipBackup
	)
	
	if (-Not $SkipBackup) {
		Backup-Database $server $database (Join-Path $workFolder ($database + "_before_unpack.bak"))
	}
	$bakFileName = "{0}.bak" -f $database
	$dbBakFile = (Join-Path $workingFolder $bakFileName ) 
	Copy-Item (Join-Path $sourceFolderUNC $bakFileName )  $dbBakFile
	Restore-Database $server $database $dbBakFile -Replace
	Truncate-Log  $server $database	
}

# Fixes common items after a database transplant.
function Fixup-Common{
	param (
		[string] $server,
		[string] $dbStem,
		[string] $EmpowerSqlPwd,
		[string] $EmpowerUserPwd,
		[switch] $encrypted
	)

	$odsDbName = $dbStem + "_ODS"

	## Fixup users SQL
	Invoke-SQL $server $dbStem ("INSERT INTO [dbo].[Log] ([Message])  VALUES  ('Fix Up SQl User EMP0WER for Database {0}')" -f $dbStem)
	Invoke-SQL $server $dbStem ("INSERT INTO [dbo].[Log] ([Message])  VALUES  ('Fix Up SQl User EMP0WER for Database {0}')" -f $odsDbName )

	## Fixup EMPOWER user Sql
	Invoke-SQL $server $dbStem ("INSERT INTO [dbo].[Log] ([Message])  VALUES  ('Fix Up EMPOWER User,  Pwd{0}')" -f $EmpowerUserPwd)

	## Fixup DB Connections
	Invoke-SQL $server $dbStem ("INSERT INTO [dbo].[Log] ([Message])  VALUES  ('Fix Up DB Connections EMPOWER Sql,  Pwd{0}')" -f $EmpowerSqlPwd)
}

function PushData {
	param (
		[string] $serverName,
		[string] $database
	)
	## sql to store system name in temp table
	Invoke-SQL $server $dbStem "INSERT INTO [dbo].[Log] ([Message])  VALUES  ('pushing system name...')"
}

function PopData {
	param (
		[string] $serverName,
		[string] $database

		## sql to retrieve system name from temp table
		## sql to drop temp table
	)
	Invoke-SQL $server $dbStem "INSERT INTO [dbo].[Log] ([Message])  VALUES  ('poping system name...')"
}

