function Assert-IsNotType {
	param(
		[Parameter(ValueFromPipeline=$true)]
		[type]$expectedType,
		[object]$object
	)
	[Xunit.Assert]::IsNotType($expectedType, $object)
}