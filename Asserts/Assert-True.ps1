function Assert-True {
	param(
		[Parameter(ValueFromPipeline=$true)]
		[bool]$condition,
		[string]$userMessage
	)
	
	if([string]::IsNullOrWhiteSpace($userMessage)){
		[Xunit.Assert]::True($condition)
	}
	else {
		[Xunit.Assert]::True($condition, $userMessage)
	}
}