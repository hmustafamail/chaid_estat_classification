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
	// Prefix the entire expression with IF 
	gen str newExpr = "IF "
	local i = 1
	local iLimit = r(nvars)
	
	// For each token
	forvalues i = 1(1)`iLimit'{
		display "in the loop`i'"
	
		// For each token, wrap it up in parentheses
		replace newExpr = newExpr + "("
	
		// Split on the @ sign into LEFT and RIGHT.
		split tokens`i', p(@)
		
		// This is left
		display "left " tokens`i'1
		
		// This is right
		display "right " tokens`i'2
		
		
		// Create a fresh token called newToken.
		local newToken = ""
		
		// Split RIGHT into words
		split tokens`i'2
		
		
		local jLimit = r(nvars)
		
		
		// For each word in RIGHT:
		forvalues j = 1(1)`jLimit'{
			// Append (LEFT == word) to newExpr
			replace newExpr = newExpr + "(" + tokens`i'1 + " == " + tokens`i'2`j' + ")"
			
			// If there is another word coming, append OR to newExpr
			if `j' < `jLimit'{
				replace newExpr = newExpr + " OR "
			}
		}
		
		// Finish wrapping those parentheses
		replace newExpr = newExpr + ")"
		
		// If there is another token, append AND to the end.
		if `i' < `iLimit'{
			replace newExpr = newExpr + " AND "
		}
	}
	// Return the expression
	display newExpr
	
end
