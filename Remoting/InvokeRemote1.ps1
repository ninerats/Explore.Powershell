[CmdletBinding()]
param()
#
# Script.ps1
#
Write-Verbose "Local verbose"
Write-Information "Local Information"
Write-Debug "Local Debug"
Write-Output "Calling remote1..."

$passthruverb = @'
	$VerbosePreference= $Using:VerbosePreference
	$DebugPreference = $Using:DebugPreference
'@
$cmd = {
	$VerbosePreference= $Using:VerbosePreference
	$DebugPreference = $Using:DebugPreference
	& "D:\git\Lab\ps1\RemoteJobs\remote1.ps1"
}
Invoke-Command -ComputerName dolly -Script $cmd
Write-Output "Complete."