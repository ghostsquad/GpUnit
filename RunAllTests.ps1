$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module (Join-Path $here "PoshUnit.psm1")
cd $here
Invoke-PoshUnit