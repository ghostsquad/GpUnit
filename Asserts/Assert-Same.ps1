function Assert-Same {
	param(
		[Object]$expected,
		[Object]$actual
	)
	[Xunit.Assert]::Same($expected, $actual)
}