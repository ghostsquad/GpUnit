function Assert-Contains
{
	param(		
		[string]$expected,
		[string]$actual,
		[System.StringComparison]$comparisonType
	)
	
	if($comparisonType -eq $null) {
		[Xunit.Assert]::Contains($expected, $actual)
	}
	else {
		[Xunit.Assert]::Contains($expected, $actual, $comparisonType)
	}
}