function Assert-True {
	param(
		[Parameter(ValueFromPipeline=$true)]
		[bool]$condition,
		[string]$userMessage
	)
	
	if([string]::IsNullOrWhiteSpace($userMessage)){
		[Xunit.Assert]::False($condition)
	}
	else {
		[Xunit.Assert]::False($condition, $userMessage)
	}
}