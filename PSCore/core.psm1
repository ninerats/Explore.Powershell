################################################################
##   Core functions the every script should have access to.   ##
################################################################

#Export-ModuleMember *-*

Set-StrictMode -Version Latest

$PSver = $PSVersionTable.PSVersion.Major
if ($PSVer -lt 3) 
{
	$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
	Import-Module "$PSScriptRoot\thunk.psm1"
}


function Get-PSHelp
 {
   param([string]$command)
   Start-process -filepath "http://ss64.com/ps/$command.html"
 }

 # https://stackoverflow.com/questions/25682507/powershell-inline-if-iif/25682508#25682508
 # Usage: "The condition is " + (IIf $Condition "True" "False") + "."
 Function IIf($If, $IfTrue, $IfFalse) {
	If ($If -IsNot "Boolean") {$_ = $If}
	If ($If) {If ($IfTrue -is "ScriptBlock") {&$IfTrue} Else {$IfTrue}}
	Else {If ($IfFalse -is "ScriptBlock") {&$IfFalse} Else {$IfFalse}}
}


 <############################### Logging  ################################>

 [string] $script:_logPath = ""
 function Start-Log
{
	param(
		[string]$logName,
		[string]$logFolder = ""
	)
	if ($logFolder -eq "")
	{
		$logFolder = $Env:ALLUSERSPROFILE
	}
	$script:_logPath = Join-Path $logFolder $logName
	
	WriteLogHeader
}

function WriteLogHeader
{
	
	if ($script:_logPath -eq "") { throw "Must call Start-Log before calling " + $MyInvocation.InvocationName  }
	Add-content $_logPath -value "`r`n################################################################################"
	Add-content $_logPath -Value "  Log started $(Get-Date)"
	Add-content $_logPath -value "################################################################################"
}

function Write-LogMsg{
	param (
		[string] $message
	)

	if ($script:_logPath -eq "") 
	{ 
		Write-Error "Must call Start-Log before calling $($MyInvocation.InvocationName)"
		return
	}
	$date = Get-Date -format "MM/dd/yyyy HH:mm:ss"
	Add-content $_logPath -value "$date`t$message"
}

function Write-LogError
{
	param (
		[string] $message
	)
	if ($script:_logPath -eq "") 
	{ 
		Write-Error "Must call Start-Log before calling $($MyInvocation.InvocationName)"
		return
	}
	Write-LogMsg "ERROR: $message"
}

function Stop-Log{
	Add-Content -Path $LogPath -Value ""
	Add-Content -Path $LogPath -Value "***************************************************************************************************"
	Add-Content -Path $LogPath -Value "Finished processing at [$([DateTime]::Now)]."
	Add-Content -Path $LogPath -Value "***************************************************************************************************"
  
	#Write to screen for debug mode
	Write-Debug ""
	Write-Debug "***************************************************************************************************"
	Write-Debug "Finished processing at [$([DateTime]::Now)]."
	Write-Debug "***************************************************************************************************"
  
}

############################################################################################

