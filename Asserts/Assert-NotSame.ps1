function Assert-NotSame {
	param(
		[Object]$expected,
		[Object]$actual
	)
	[Xunit.Assert]::NotSame($expected, $actual)
}