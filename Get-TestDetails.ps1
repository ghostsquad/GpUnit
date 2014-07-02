function Get-TestDetails {
	param (
		[string]$testName,
		[switch]$failedTests
	)
	
	$tests = @()
	
	if($failedTests){
		$tests = @($global:testResults | ?{$_.Result -eq "failed"})
	}
	else {
		$tests += ($global:testResults | ?{$_.name -eq $testName})
	}
	
	if($tests.Count -eq 0 -and $failedTests -eq $false)	{
		Write-Host "No test found with name [$testName]" -ForegroundColor Red	
	}
	elseif($tests.Count -eq 0) {
		Write-Host "No failed tests!" -ForegroundColor Red	
	}
	
	Write-Host
	Write-Host "-----------------------------------------------"
	
	foreach($test in $tests) {
		Write-Host "Fixture : " -ForegroundColor Yellow -NoNewline
		Write-Host $test.Fixture
		Write-Host "TestName: " -ForegroundColor Yellow -NoNewline
		Write-Host $test.Name
		Write-Host "Result  : " -ForegroundColor Yellow -NoNewline
		if($test.Result -eq "passed"){
			Write-Host $test.Result -ForegroundColor Green
		}
		else {
			Write-Host $test.Result -ForegroundColor Red
		}
		Write-Host
		Write-Host "Output" -ForegroundColor Yellow
		Write-Host "---------------------"
		Write-Host
		Write-Host $test.Output	
		Write-Host
		Write-Host "-----------------------------------------------"
		Write-Host
	}
}