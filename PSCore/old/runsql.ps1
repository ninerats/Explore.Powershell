function Run-SQL {
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
	Write-Debug "bakpath=$bakpath, database=$dabase"
	Run-SQL $server $database $sql
} 