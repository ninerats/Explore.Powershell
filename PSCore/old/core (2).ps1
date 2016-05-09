$PSver = $PSVersionTable.PSVersion.Major
if ($PSVer -lt 3) 
{
	$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
	. "$PSScriptRoot\thunk.ps1"
}


function Get-PSHelp
 {
   param([string]$command)
   Start-process -filepath "http://ss64.com/ps/$command.html"
 }