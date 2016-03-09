// Mustafa Hussain
// Spring 2016
//
// chaid_estat_classification - Postestimation classifier accuracy metrics for CHAID
// Written for STATA 13
//
// Usage example:
// chaidestat classification if !mod(observation + 4, 9)
//
// The IF statement is optional. If it is not supplied, the entire dataset is 
// classified.

// dependency function
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

capture program drop chaid_estat_classification
program define chaid_estat_classification
*! Postestimation classifier accuracy metrics for CHAID v1 GR 2-Feb-16
	version 13.0
	syntax [if]
	
	// Generate a user selection based on user's IF expression.
	// If they do not supply an IF, the variable is always 1! Yay!
	//display `"if now contains [`if']"'
	quietly gen usrSel=1 `if'
	quietly replace usrSel=0 if usrSel==.
	// list usrSel
	
	// Grab the dependent var and number of leaf nodes from CHAID's return vars.
	local predictedVariable = e(depvar)
	
	quietly local iLimit = e(N_clusters)
	
	// This will be what CHAID classified values as.
	quietly gen classifiedAs = 0
	
	// For each cluster, create its IF statement, generate data labels.
	forvalues i = 1(1)`iLimit'{
		local path`i' = e(path`i')
		local currPath = "path`i'"
		
		//display ""
		//display "About to generate logical expression for path `i'"
		
		quietly generate_one_path_expression `"`path`i''"'
		
		// Infer what CHAID would have labelled this cluster.
		quietly egen mode`i' = mode(acute), maxmode, `r(newExpression)'
		//list mode`i'
		
		// Replace missing values with zeros, for piecing together.
		quietly replace mode`i'=0 if mode`i'==.
		
		// Piece those mode sets together to create a variable that represents 
		// how CHAID classified this dataset.
		quietly replace classifiedAs=classifiedAs+mode`i'
	}
	
	// This is the agreement between the classifier and the given labels.
	quietly gen agreements = classifiedAs == `predictedVariable'
	quietly count if agreements & usrSel
	local correctlyClassified = r(N)
	
	// This is the total number of observations.
	quietly count if usrSel
	local numObs = r(N)
	
	// Count true positives
	quietly gen truePos = classifiedAs & `predictedVariable'
	quietly count if truePos & usrSel
	local truePositives = r(N)
	
	// Count true negatives
	quietly gen trueNeg = !classifiedAs & !`predictedVariable'
	quietly count if trueNeg & usrSel
	local trueNegatives = r(N)
	
	// Count false negatives
	quietly gen falseNeg = !classifiedAs & `predictedVariable'
	quietly count if falseNeg & usrSel
	local falseNegatives = r(N)
	
	// Count false positives
	quietly gen falsePos = classifiedAs & !`predictedVariable'
	quietly count if falsePos & usrSel
	local falsePositives = r(N)
	
	local classifiedPositives = `truePositives' + `falsePositives'
	local classifiedNegatives = `trueNegatives' + `falseNegatives'
	
	local actualPositives = `truePositives' + `falseNegatives'
	local actualNegatives = `trueNegatives' + `falsePositives'
	
	local classifiedObservations = `actualPositives' + `actualNegatives'
	
	// Sensitivity and Specificity
	local sensitivityPercent = (`truePositives' / `actualPositives') * 100
	local specificityPercent = (`trueNegatives' / `actualNegatives') * 100
	
	// Positive and Negative Predictive Value
	quietly count if classifiedAs & usrSel
	local classifiedAsPositive = r(N)
	local positivePredictiveValuePercent = (`truePositives' / `classifiedAsPositive') * 100
	
	quietly count if !classifiedAs & usrSel
	local classifiedAsNegative = r(N)
	local negativePredictiveValuePercent = (`trueNegatives' / `classifiedAsNegative') * 100
	
	// Longest possible var name is 31 chars
	local falsePosRateForActuallyFalse = (`falsePositives' / `actualNegatives') * 100
	local falseNegRateForActuallyTrue = (`falseNegatives' / `actualPositives') * 100
	local falsePosRateForClassifiedTrue = (`falsePositives' / `classifiedAsPositive') * 100
	local falseNegRateForClassifiedFalse = (`falseNegatives' / `classifiedAsNegative') * 100
	
	local correctlyClassifiedPercent = (`correctlyClassified' / `numObs') * 100
	
	// Finally, print everything out (51 columns wide)
	display ""
	display "{error}NOTE:"
	display "{error} (1) Testing has been limited to examining a case of predicting one binary variable."
	display "{error} (2) This function assumes the tree errs on the side of safety, preferring"
	display "{error} 	false positives if it is unsure."
	display "{txt}"
	display "{txt}{title:Decision tree model for `predictedVariable'}"
	display ""
	display "{ralign 39:{c TLC}{hline 12} Actual {hline 6}{c TRC}}"
	display "Classified {c |}{ralign 10: D}{dup 3: }{ralign 11: ~D}{dup 2: }{c |}{ralign 11: Total}"
	display "{hline 11}{c +}{hline 26}{c +}{hline 11}"	
	display "{center 11: +}{c |}" %10.0g `truePositives' "{dup 3: }" %11.0g `falsePositives' "{dup 2: }{c |}" %11.0g `classifiedPositives'
	display "{center 11: -}{c |}" %10.0g `falseNegatives' "{dup 3: }" %11.0g `trueNegatives' "{dup 2: }{c |}" %11.0g `classifiedNegatives'
	display "{hline 11}{c +}{hline 26}{c +}{hline 11}"	
	display "{center 11: Total}{c |}" %10.0g `actualPositives' "{dup 3: }" %11.0g `actualNegatives' "{dup 2: }{c |}" %11.0g `classifiedObservations'
	display ""
	display "Classified by tree"
	display "True D defined as `predictedVariable' != 0"
	display "{hline 50}"
	display "{lalign 32:Sensitivity}Pr( +| D)" %8.2f `sensitivityPercent' "%"
	display "{lalign 32:Specificity}Pr( -|~D)" %8.2f `specificityPercent' "%"
	display "{lalign 32:Positive predictive value}Pr( D| +)" %8.2f `positivePredictiveValuePercent' "%"
	display "{lalign 32:Negative predictive value}Pr(~D| -)" %8.2f `negativePredictiveValuePercent' "%"
	display "{hline 50}"
	display "{lalign 32:False + rate for true ~D}Pr( +|~D)" %8.2f `falsePosRateForActuallyFalse' "%"
	display "{lalign 32:False - rate for true D}Pr( -| D)" %8.2f `falseNegRateForActuallyTrue' "%"
	display "{lalign 32:False + rate for classified +}Pr(~D| +)" %8.2f `falsePosRateForClassifiedTrue' "%"
	display "{lalign 32:False - rate for classified -}Pr( D| -)" %8.2f `falseNegRateForClassifiedFalse' "%"
	display "{hline 50}"
	display "{lalign 40:Correctly classified}" %9.2f `correctlyClassifiedPercent' "%"
	display "{hline 50}"
	
	// Clean up
	drop mode*
	drop true*
	drop false*
	drop agreements
	drop classifiedAs
	drop usrSel
	
end
