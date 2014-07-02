function Assert-NotEmpty {
	param(
		[Parameter(ValueFromPipeline=$true)]
		[System.Collections.IEnumerable]$collection
	)
	[Xunit.Assert]::NotEmpty($collection)
}