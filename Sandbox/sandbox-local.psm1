#
# sandbox_local.psm1
#

########################################################################################################

$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition ## for v.2 and lower.
. $PSScriptRoot\paths.ps1

### Imports #######################################################################################################

Import-Module -Verbose $libroot\Core.psm1
Import-Module  -Verbose  "$libroot\database.psm1"
Import-Module  -Verbose  "$PSScriptRoot\sandbox-common.psm1"

### Exported Functions ############################################################################################

#Export-ModuleMember -Function Update-SandboxDatabases

function Update-SandboxDatabases {
	param(
		[string] $backupFolder,
		[string] $server="localhost",
		[string] $dbStem="LoanSphere"
	)
	
	PushData $server $dbStem

	Unpack-Databases $backupFolder "(localdb)\v11.0" $dbStem C:\temp "EMPOWER_sql_pwd" "EMPOWER_userPwd"

	Environmentalize

	PopData $server $dbStem

}

### Helper Functions ##############################################################################################

function Environmentalize {
	# runs Sandbox - specific fix-up scripts.
}