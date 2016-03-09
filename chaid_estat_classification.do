// Mustafa Hussain
// Spring 2016
//
// chaid_estat_classification - Postestimation classifier accuracy metrics for CHAID
// Written for STATA 13
//
// Usage example:
// chaidestat classification if !mod(observation + 4, 9)

// import dependency functions
do "generate_one_path_expression.do"

capture program drop chaid_estat_classification
program define chaid_estat_classification
*! Postestimation classifier accuracy metrics for CHAID v1 GR 2-Feb-16
	version 13.0
	//syntax [if]
	
	// Grab the dependent var and number of leaf nodes from CHAID's return vars.
	local predictedVariable = e(depvar)
	
	quietly local iLimit = e(N_clusters)
	
	// This will be what CHAID classified values as.
	gen classifiedAs = 0
	
	// For each cluster, create its IF statement, generate data labels.
	forvalues i = 1(1)`iLimit'{
		local path`i' = e(path`i')
		local currPath = "path`i'"
		
		display ""
		display "About to generate logical expression for path `i'"
		
		generate_one_path_expression `"`path`i''"'
		
		// Infer what CHAID would have labelled this cluster.
		egen mode`i' = mode(acute), maxmode, `r(newExpression)'
		//list mode`i'
		
		// Replace missing values with zeros, for piecing together.
		replace mode`i'=0 if mode`i'==.
		
		// Piece those mode sets together to create a variable that represents 
		// how CHAID classified this dataset.
		replace classifiedAs=classifiedAs+mode`i'
	}
	
	// This is the agreement between the classifier and the given labels.
	gen agreements = classifiedAs == `predictedVariable'
	count if agreements
	local correctlyClassified = r(N)
	
	// This is the total number of observations.
	count
	local numObs = r(N)
	
	// Count true positives
	gen truePos = classifiedAs & `predictedVariable'
	count if truePos
	local truePositives = r(N)
	
	// Count true negatives
	gen trueNeg = !classifiedAs & !`predictedVariable'
	count if trueNeg
	local trueNegatives = r(N)
	
	// Count false negatives
	gen falseNeg = !classifiedAs & `predictedVariable'
	count if falseNeg
	local falseNegatives = r(N)
	
	// Count false positives
	gen falsePos = classifiedAs & !`predictedVariable'
	count if falsePos
	local falsePositives = r(N)
	
	local classifiedPositives = `truePositives' + `falsePositives'
	local classifiedNegatives = `trueNegatives' + `falseNegatives'
	
	local actualPositives = `truePositives' + `falseNegatives'
	local actualNegatives = `trueNegatives' + `falsePositives'
	
	local classifiedObservations = `actualPositives' + `actualNegatives'
	
	local sensitivityPercent = (`truePositives' / `actualPositives') * 100
	local specificityPercent = (`trueNegatives' / `actualNegatives') * 100
	
	// TODO: Determine accuracy stats on this new dataset
	count if classifiedAs
	local classifiedAsPositive = r(N)
	local positivePredictiveValuePercent = (`truePositives' / `classifiedAsPositive') * 100
	
	count if !classifiedAs
	local classifiedAsNegative = r(N)
	local negativePredictiveValuePercent = (`trueNegatives' / `classifiedAsNegative') * 100
	
	// Longest possible var name is 31 chars
	local falsePosRateForActuallyFalse = 84.947
	local falseNegRateForActuallyTrue = 85.947
	local falsePosRateForClassifiedTrue = 86.947
	local falseNegRateForClassifiedFalse = 87.947
	
	local correctlyClassifiedPercent = (`correctlyClassified' / `numObs') * 100
	
	// Finally, print everything out (51 columns wide)
	display ""
	display "{error}NOTE: PROTOTYPE -- NOT FULLY IMPLEMENTED"
	display "{error}NOTE: TESTING HAS BEEN LIMITED TO EXAMINING A CASE OF PREDICTING ONE BINARY VARIABLE."
	display "{error}Also note that this assumes the tree errs on the side of safety, preferring false positives if it is unsure."
	display "{error}Also note that this actually ignores your IF expression right now :D"
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
	
end
