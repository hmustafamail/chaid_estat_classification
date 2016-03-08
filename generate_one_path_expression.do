capture program drop generate_one_path_expression
program define generate_one_path_expression, rclass
*! Generates an IF statement from one path description
	version 13.0
	
	// Grab our expression.
	if "`1'" == "" {
		display as error "syntax: generate_one_expression path_description"
		exit 198
	}
	
	// This is our expression.
	quietly gen str tokens = `"`1'"'
	
	display "tokens: " tokens
	
	// Tokens are separated by semicolons. 
	// Split this expression up into a list of tokens.
	quietly split tokens, parse(;)
	
	// Setting up for building new expression.
	// Prefix the entire expression with IF 
	gen str newExpr = "if "
	local i = 1
	local iLimit = r(nvars)
	
	// For each token
	forvalues i = 1(1)`iLimit'{
		// For each token, wrap it up in parentheses
		quietly replace newExpr = newExpr + "("
	
		// Split on the @ sign into LEFT and RIGHT.
		quietly split tokens`i', p(@)
		
		// This is left
		display "left " tokens`i'1
		
		// This is right
		display "right " tokens`i'2
		
		// Create a fresh token called newToken.
		quietly local newToken = ""
		
		// Split RIGHT into words
		quietly split tokens`i'2
		
		local jLimit = r(nvars)
		
		// For each word in RIGHT:
		forvalues j = 1(1)`jLimit'{
			// Append (LEFT == word) to newExpr
			quietly replace newExpr = newExpr + "(" + tokens`i'1 + " == " + tokens`i'2`j' + ")"
			
			// If there is another word coming, append OR to newExpr
			if `j' < `jLimit'{
				quietly replace newExpr = newExpr + " | "
			}
		}
		
		// Finish wrapping those parentheses
		quietly replace newExpr = newExpr + ")"
		
		// If there is another token, append AND to the end.
		if `i' < `iLimit'{
			quietly replace newExpr = newExpr + " & "
		}
	}
	
	
	// Return the expression
	display newExpr
	return local newExpression = newExpr
	
	// Clean up
	drop tokens*
	drop newExpr
end
