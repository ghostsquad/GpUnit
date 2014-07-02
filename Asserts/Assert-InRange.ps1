function Assert-InRange {
	param(
		[Parameter(ValueFromPipeline=$true)]
		[object]$actual,
		[object]$low,
		[object]$high,
		[object]$comparer
	)
	
	if($comparer -eq $null) {
		[Xunit.Assert]::InRange($actual, $low, $high)
	}
	else {
		[Xunit.Assert]::InRange($actual, $low, $high, $comparer)
	}
}