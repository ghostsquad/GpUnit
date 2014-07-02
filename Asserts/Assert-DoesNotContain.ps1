function Assert-DoesNotContain {
	param(
		[string]$expected,
		[string]$actual,
		[System.StringComparison]$comparisonType
	)
	
	if($comparisonType -eq $null){
		[Xunit.Assert]::DoesNotContain($expected, $actual)
	}
	else {
		[Xunit.Assert]::DoesNotContain($expected, $actual, $comparisonType)
	}
}