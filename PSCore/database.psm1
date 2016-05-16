#
# Database related functions.  NOTE: There's a good chance using SMO is better than this.
# NOTE 2: There's a good chance The SQLPS module is better than SMO, for 2012.  Should use this instead if available.
#



Import-Module "$PSScriptRoot\thunk.psm1"

function Invoke-SQL {
	param(
		[string] $dataSource,
		[string] $database,
		[string] $sqlCommand = $(throw "Please specify a query.")
	  )

	$connectionString = "Data Source=$dataSource; " +
			"Integrated Security=SSPI; " +
			"Initial Catalog=$database"

	$connection = new-object system.data.SqlClient.SQLConnection($connectionString)
	$command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
	$connection.Open()
	
	$adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
	$dataset = New-Object System.Data.DataSet
	$adapter.Fill($dataSet) | Out-Null
	
	$connection.Close()
	$dataSet.Tables 
}

function Backup-Database {
	param(
		[string] $server,
		[string] $database,
		[string] $bakpath
	)

	$template = "BACKUP DATABASE [{dbname}] TO  DISK = N'{bakpath}' WITH NOFORMAT, INIT,  NAME = N'{dbname}-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10"
	$sql = $template -replace "{dbname}",$database -replace "{bakpath}",$bakpath
	Write-Debug "bakpath=$bakpath, database=$database"
	Invoke-SQL $server $database $sql
} 

function Restore-Database {
param(
		[string] $server,
		[string] $database,
		[string] $bakpath,
		[switch] $replace
	)
	$template = "USE [master] RESTORE DATABASE [{0}] FROM  DISK = N'{0}' WITH  FILE = 1,  NOUNLOAD,  {2} STATS = 5"
	$sql = $template -f $database,$bakpath, (IIf $replace "WITH REPLACE" "")
	Write-Debug "bakpath=$bakpath, database=$database, replace=$replace"
	Invoke-SQL $server $database $sql
}

Add-Type -TypeDefinition @"
   public enum RecoveryMode
   {
	  Simple,
	  Full,
	  BulkLogged
   }
"@

function Truncate-Log {
	param(
		[string] $server,
		[string] $database,
		[RecoveryMode] $recovery="Simple"
	)
	$result = Invoke-SQL $server $database "SELECT name FROM sys.master_files WHERE database_id = db_id()  AND type = 1"
	$logFileName = $result.Rows[0].Item(0)
	if ($recovery -eq "Simple") {
		$sql = "DBCC SHRINKFILE({0}, TRUNCATEONLY)" -f $logFileName
	}
	else {
		throw "Recovery mode {0} is Not supported" -f $recovery
	}
	
	Write-Debug "server=$server, database=$database, RecoveryMode=$RecoveryMode"
	Invoke-SQL $server $database $sql

}
