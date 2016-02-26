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
	scalar inputExpression = `"`1'"'
	display "this is our input expresison"
	display inputExpression
	display "that was our input expresison"
	
	// Tokens are separated by semicolons. 
	// Split this expression up into a list of tokens.
	split inputExpression, p(;), gen(tokens)
	
	display "hey"
	
	local newExpression = ""
	
	// For each token
	foreach token in `tokens'{
		// Split on the @ sign into LEFT and RIGHT.
		split `"`token'"', p(@), gen(leftAndRight)
		
		// This is left
		display "left"
		display leftAndRight1
		
		// This is right
		display "right"
		display leftAndRight1
		
		// Create a fresh token called newToken.
		local newToken = ""
		
		// For each word in RIGHT:
			// Append (LEFT == word) to newToken.
			// If there is another word coming, append “ or ” to newToken.
	}
	
	// Join the tokens together. For each token:
		// Wrap it up in parentheses
		// If there is another token, append “ and ” to the end.
		
	// Prefix the entire expression with “if ”
	// Return the expression
	
end

