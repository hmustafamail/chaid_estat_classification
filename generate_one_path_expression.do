capture program drop generate_one_path_expression
program define generate_one_path_expression
*! Generates if statement from one path description
	version 13.0
	
	// Grab our expression.
	if "`1'" == "" {
		display as error "syntax: generate_one_expression path_description"
		exit 198
	}
	
	// This is our expression.
	display `"`1'"'
	gen str tokens = `"`1'"'
	
	display "tokens: " tokens
	
	// Tokens are separated by semicolons. 
	// Split this expression up into a list of tokens.
	split tokens, parse(;)
	
	// Setting up for building new expression.
	gen str newExpr = ""
	local i = 1
	
	// For each token that exists
	capture confirm variable "tokens`i'"
	while(_rc){
		display "in the loop`i'"
	
		// Split on the @ sign into LEFT and RIGHT.
		split tokens`i', p(@)
		
		// This is left
		display "left " tokens`i'1
		
		// This is right
		display "right " tokens`i'2
		
		// Create a fresh token called newToken.
		local newToken = ""
		
		// For each word in RIGHT:
			// Append (LEFT == word) to newToken.
			// If there is another word coming, append “ or ” to newToken.
		
		
		local i = `i' + 1
		//local curTok = tokens`i'
		display "now on " `i' " which is " tokens`i'
		capture confirm variable "tokens`i'"
		display _rc
	}
	
	// Join the tokens together. For each token:
		// Wrap it up in parentheses
		// If there is another token, append “ and ” to the end.
		
	// Prefix the entire expression with “if ”
	// Return the expression
	
end

