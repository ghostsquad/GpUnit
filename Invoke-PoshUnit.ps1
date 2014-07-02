function Invoke-PoshUnit {
	[cmdletbinding()]
	param(
        [string]$Path = $(Get-Location)
	)
	
	$ErrorActionPreference = "Stop"
	
	$testPath = Resolve-Path $Path
	
	$testFiles = Get-ChildItem $testPath -Filter "*.tests.ps1" -Recurse
	
	$modulePath = (Get-Module PoshUnit).Path
	$global:testResults = @()
	
	$segment_CreateNameScriptBlockPair = '| %{New-Object -TypeName PSObject -Property @{Name = $_.Name; ScriptBlock = $_.Value}}'
	
	foreach($testFile in $testFiles) {
		$testFileContents = [system.io.file]::ReadAllText($testFile.Fullname)
		$testFileContentsAsScriptBlock = [scriptblock]::Create($testFileContents)
		
		$testFixtureRetrievalScriptBlockString = $testFileContents `
			+ (GetVariableTestMethodTypeString 'IsPoshUnitTestFixture') `
			+ (GetNamedScriptBlockString)
		
		$testFixtures = @([scriptblock]::Create($testFixtureRetrievalScriptBlockString).Invoke())
		
		foreach($testFixture in $testFixtures) {		
			$testSetupDefinition = GetTestSetupDefinition $testFixture
			$testTeardownDefinition = GetTestTeardownDefinition $testFixture
			$testDefinitions = GetTestDefinitions $testFixture
			$privateMethodsDictionary = GetPrivateMethodsDictionary $testFixture
			$privateVariables = GetPrivateVariables $testFixture
			
			$global:testResults += RunTestCases $testFixture $testDefinitions
		}		
	}

	$passedTestCases = @()
	$failedTestCases = @()	

	foreach($testCase in $global:testResults) {
		if($testCase.Result -eq "passed") {
			$passedTestCases += $testCase
		}
		else {
			$failedTestCases += $testCase
		}
	}
	
	WriteTestResults $passedTestCases $failedTestCases
}

function RunTestCases {
	param (
		[PSObject]$testFixture,
		[PSObject[]]$testDefinitions
	)
	
	function NewTestData {
		param(
			[string]$fixtureName,
			[string]$testName
		)		
		New-Object -TypeName PSObject -Property @{
			Fixture = $fixtureName
			Name = $testName
			Result = "NotRun"
			Output = [string]::Empty
			Exception = $null
		}
	}
	
	foreach($test in $testDefinitions) {
		$testData = NewTestData $testFixture.Name $test.Name
		$testScriptBlockString = "Import-Module '$modulePath';"
		$testScriptBlockString += $testFixture.ScriptBlock.ToString() + ";"
		$testScriptBlockString += $test.ScriptBlock.ToString() + ";"
		$testScriptBlock = [scriptblock]::Create($testScriptBlockString)
		Try {
			$testData.Output = Invoke-Command -ScriptBlock $testScriptBlock
			$testData.Result = "Passed"
		}
		Catch [Exception] {
			$exception = $_
			$testData.Result = "Failed"
			$testData.Exception = $exception
			$testData.Output += $exception.Exception | format-list -force | Out-String | %{$_.Trim("`r", "`n", " ")}
		}
		
		Write-Output $testData
	}
}

function GetTestDefinitions {
	param (
		[PSObject]$testFixture
	)
	
	$unitTestsRetrievalScriptBlockString = $testFixture.ScriptBlock.ToString() `
		+ (GetVariableTestMethodTypeString 'IsPoshUnitTest') `
		+ (GetNamedScriptBlockString)
		
	Write-Output (GetDefinitionFromScriptBlockString $unitTestsRetrievalScriptBlockString)
}

function GetTestSetupDefinition {
	param (
		[PSObject]$testFixture
	)
	
	$testSetupRetrievalScriptBlockString = $testFixture.ScriptBlock.ToString() `
		+ (GetVariableTestMethodTypeString 'IsPoshUnitTestSetup') `
		+ '| %{$_.Value}'

	Write-Output (GetDefinitionFromScriptBlockString $testSetupRetrievalScriptBlockString)
}

function GetTestTeardownDefinition {
	param (
		[PSObject]$testFixture
	)
	
	$testTeardownRetrievalScriptBlockString = $testFixture.ScriptBlock.ToString() `
		+ (GetVariableTestMethodTypeString 'IsPoshUnitTestTeardown') `
		+ '| %{$_.Value}'

	Write-Output (GetDefinitionFromScriptBlockString $testTeardownRetrievalScriptBlockString)
}



function GetDefinitionFromScriptBlockString {
	param (
		[string]$scriptBlockString
	)
	
	Write-Output @([scriptblock]::Create($scriptBlockString).Invoke())
}

function GetTestSetupMethod {
	param(
		[scriptblock]$testFixtureScriptBlock
	)
}

function GetVariableTestMethodTypeString {
	param(
		[string]$methodType
	)
	
	$value = '; gci variable:\ | ?{$_.Value.' + $methodType + '}'
	Write-Output $value
}

function GetNamedScriptBlockString {
	return '| %{New-Object -TypeName PSObject -Property @{Name = $_.Name; ScriptBlock = $_.Value}}'
}

function GetPrivateVariables {
	$privateVariablesRetrievalScriptBlockString = $testFixture.ScriptBlock.ToString() `
		+ '; gci variable:\ | ?{-not $_.Value.IsPoshUnitTest -and -not ' `
		+ '$_.Value.IsPoshUnitTestTeardown -and -not $_.Value.IsPoshUnitTestSetup}'
	
	$privateVariables = @([scriptblock]::Create($privateVariablesRetrievalScriptBlockString).Invoke())
}

function GetPrivateMethodsDictionary {
	param (
		[PSObject]$testFixture
	)
	
	$privateMethodsDictionary = New-Object 'system.collections.generic.dictionary[[string],[ScriptBlock]]'
	
	$privateMethodsRetrievalScriptBlockString = $testFixture.ScriptBlock.ToString() `
		+ '; gci function:\'
	
	$privateMethods = @([scriptblock]::Create($privateMethodsRetrievalScriptBlockString).Invoke())
	$privateMethods | %{
		$privateMethodsDictionary.Add($_.Name, $_.ScriptBlock)
	}
	
	return $privateMethodsDictionary
}

function WriteTestResults {
	param(
		[Object[]]$passedTestCases,
		[Object[]]$failedTestCases
	)
	$testCaseCategoryDivider = "---------------------"

	Write-Host

	Write-Host "Passed" -ForegroundColor Green -NoNewline
	Write-Host (" ({0})" -f $passedTestCases.Count) -ForegroundColor White
	Write-Host $testCaseCategoryDivider
	$passedTestCases | %{ 
		Write-Host " + " -ForegroundColor Black -BackgroundColor Green -NoNewline
		Write-Host $(" " + $_.Fixture + "." + $_.Name)
	}

	Write-Host

	Write-Host "Failed" -ForegroundColor Red -NoNewline
	Write-Host (" ({0})" -f $failedTestCases.Count) -ForegroundColor White
	Write-Host $testCaseCategoryDivider
	$failedTestCases | %{ 
		Write-Host " + " -ForegroundColor Black -BackgroundColor Red -NoNewline
		Write-Host $(" " + $_.Fixture + "." + $_.Name)
	}

	Write-Host
	Write-Host 'run Get-TestDetails for individual test details'
}