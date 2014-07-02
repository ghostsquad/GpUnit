function Assert-NotInRange {
	param(
		[Parameter(ValueFromPipeline=$true)]
		[object]$actual,
		[object]$low,
		[object]$high,
		[object]$comparer
	)
	
	if($comparer -eq $null) {
		[Xunit.Assert]::NotInRange($actual, $low, $high)
	}
	else {
		[Xunit.Assert]::NotInRange($actual, $low, $high, $comparer)
	}
}