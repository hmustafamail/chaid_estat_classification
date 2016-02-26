capture program drop generate_one_path_expression
program define generate_one_path_expression
*! Generates if statement from path description
	version 13.0
	//args pathDescription
	
	while "`1'" != "" {
		display `"`1'"'
		display "yay"
		mac shift
	}

	
	// Grab our expression.
	//confirm variable pathDescription
	
	// Tokens are separated by semicolons. 
	// Split this expression up into a list of tokens.
	
	
	// For each token
		// Split on the @ sign into LEFT and RIGHT.
		// Create a fresh token called newToken.
		// For each word in RIGHT:
			// Append (LEFT == word) to newToken.
			// If there is another word coming, append “ or ” to newToken.
	
	// Join the tokens together. For each token:
		// Wrap it up in parentheses
		// If there is another token, append “ and ” to the end.
		
	// Prefix the entire expression with “if ”
	// Return the expression
	
end

