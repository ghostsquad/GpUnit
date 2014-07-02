$here = Split-Path -Parent $MyInvocation.MyCommand.Path

Add-Type -Path (Join-Path $here "xunit.dll")

# Core
. $here\Invoke-PoshUnit.ps1
. $here\New-TestFixture.ps1
. $here\New-TestSetup.ps1
. $here\New-TestTeardown.ps1
. $here\New-Test.ps1
. $here\Get-TestDetails.ps1

# Xunit Asserts
. $here\Asserts\Assert-Contains.ps1
. $here\Asserts\Assert-DoesNotContain.ps1
. $here\Asserts\Assert-DoesNotThrow.ps1
. $here\Asserts\Assert-Empty.ps1
. $here\Asserts\Assert-Equal.ps1
. $here\Asserts\Assert-False.ps1
. $here\Asserts\Assert-InRange.ps1
. $here\Asserts\Assert-IsAssignableFrom.ps1
. $here\Asserts\Assert-IsNotType.ps1
. $here\Asserts\Assert-IsType.ps1
. $here\Asserts\Assert-NotEmpty.ps1
. $here\Asserts\Assert-NotEqual.ps1
. $here\Asserts\Assert-NotInRange.ps1
. $here\Asserts\Assert-NotNull.ps1
. $here\Asserts\Assert-NotSame.ps1
. $here\Asserts\Assert-Null.ps1
. $here\Asserts\Assert-Same.ps1
. $here\Asserts\Assert-Single.ps1
. $here\Asserts\Assert-Throws.ps1
. $here\Asserts\Assert-True.ps1



$global:PoshUnit = New-Object PSObject -Property @{
	Version = "0.1 Alpha"
}

Export-ModuleMember -Function *-*