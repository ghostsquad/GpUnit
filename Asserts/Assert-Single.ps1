function Assert-Single {
	param(
		[System.Collections.IEnumerable]$collection,
		[Object]$expected
	)
	
	if($expected -eq $null) {
		[Xunit.Assert]::Single($collection)
	}
	else {
		[Xunit.Assert]::Single($collection, $expected)
	}
}