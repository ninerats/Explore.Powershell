
#
# Test script for sandbox-local.
#

########################################################################################################

$here = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition ## for v.2 and lower.
. $here\paths.ps1

### Imports #######################################################################################################

Import-Module $libroot\Core.psm1
Import-Module -Verbose "$here\sandbox-local.psm1"

Update-SandboxDatabases "\\VBOXSVR\shared\baks"