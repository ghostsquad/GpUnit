function Assert-Throws {
	param(
		[Type]$exceptionType,
		[Delegate]$testCode
	)
	[Xunit.Assert]::Throws($exceptionType, $testCode)
}