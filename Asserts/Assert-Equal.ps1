function Assert-Equal {
	param(
		[Parameter(ValueFromPipeline=$true)]
		[object]$expected,
		[object]$actual		
	)
	[Xunit.Assert]::Equal($expected, $actual)
}