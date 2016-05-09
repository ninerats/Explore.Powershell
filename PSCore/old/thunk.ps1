
#compatiblity layer for powershell versions < 3.0

$PSver = $PSVersionTable.PSVersion.Major
if ($PSVer -lt 3) 
{
	$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}