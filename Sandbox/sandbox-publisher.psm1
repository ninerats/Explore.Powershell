#
# sandbox_publisher.psm1
#

########################################################################################################
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition ## for v.2 and lower.
. $PSScriptRoot\paths.ps1
### Imports #######################################################################################################
Import-Module -Verbose $libroot\Core.psm1
Import-Module  -Verbose  "$libroot\database.psm1"

function Pack-Database {
	params(
		[string] $server,
		[string] $dbStem,
		[string] $backupFolder,
		[string] $dest
	)
try
{
	# LoanSphere database
	$dbName = $dbStem
	$bakfile = Join-Path $backupFolder ($dbName + ".bak")
	Backup-Database  $server $dbName $bakfile
	Move-Item $bakfile $dest

	# ODS database
	$odsDbName = $dbStem + "_ODS"
	$odsbakfile = Join-Path $backupFolder ($odsDbName + ".bak")
	Backup-Database  $server $dbName $odsbakfile
	Move-Item $odsbakfile $dest
}
catch [System.Exception]
{
	Write-Host "<!<SnippetOtherException>!>"
}
finally
{
	Write-Host "<!<SnippetCleaningUp>!>"
}
}

