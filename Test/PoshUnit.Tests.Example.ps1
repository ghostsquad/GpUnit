$myTestFixture = New-TestFixture {	
	$foo = "hello world"

	$setup = New-TestSetup {		
		Write-Output "Setup"
	}
	
	$teardown = New-TestTeardown {
		Write-Output "Teardown"
	}
	
	$testFail = New-Test {
		throw "omg! wtf happened?"
	}
	
	$test1 = New-Test {
		Write-Output "Test1!"
	}
	
	$testFoo = New-Test {
		Write-Output "value of foo: $foo"
	}
}