function Assert-Null {
	param(
		[Parameter(ValueFromPipeline=$true)]
		[Object]$object
	)
	[Xunit.Assert]::Null($object)
}