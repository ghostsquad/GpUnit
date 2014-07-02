$outOfScope = "this should be out of scope"

$VariableAccessTests = New-TestFixture {	
	$foo = "hello world"
	$complexObject = New-Object -TypeName PSObject -Property @{
		Foo = "hello world"
	}
	
	$bar = 1
	
	$CanAccessParentVariable = New-Test {
		Assert-Equal "hello world" $foo
	}
	
	$WhenNewPrimitiveDeclared_ExpectDoesNotChangeParentScopedVariable = New-Test {
		Assert-Equal "hello world" $foo
		$foo = "goodbye world"
		$topLevelFoo = Get-Variable -Scope 2 -Name "foo" -ValueOnly
		Assert-NotNull $topLevelFoo
		Assert-NotEqual $foo $topLevelFoo
	}
	
	$ExpectTestsRunInIsolation1 = New-Test {
		Assert-Equal 1 $bar
		$bar++
		Assert-Equal 2 $bar
	}
	
	$ExpectTestsRunInIsolation2 = New-Test {
		Assert-Equal 1 $bar
		$bar++
		Assert-Equal 2 $bar
	}
	
	$ExpectNotToAccessOutOfScopeVariable = New-Test {
		Assert-Null $outOfScope
	}
}