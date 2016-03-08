// Mustafa Hussain
// Spring 2016
// chaid_estat_classification - Postestimation classifier accuracy metrics for CHAID
// Written for STATA 13


set more off

// import dependency functions
do "generate_one_path_expression.do"

// command prototype
// chaidestat classification if !mod(observation + 4, 9)

capture program drop chaid_estat_classification
program define chaid_estat_classification
*! Postestimation classifier accuracy metrics for CHAID v1 GR 2-Feb-16
	version 13.0
	//syntax [if]
	
	// TODO: Grab all the stuff from CHAID's return registers
	local predictedVariable = e(depvar)
	
	// TODO: Use generate_one_path_expression to create IF statement, generate new dataset
	quietly local iLimit = e(N_clusters)
	forvalues i = 1(1)`iLimit'{
	
		//local path1 = e(path1)
		//generate_one_path_expression `"`path1'"'	
		local path`i' = e(path`i')
		local currPath = "path`i'"
		
		display "about to generate for path `i'"
		
		generate_one_path_expression `"`path`i''"'
		
		// TODO: Classify this new dataset based on the tree
		
		// Inferring the value of this cluster (would rather not do that)
		// TODO: This keeps tripping over missing values, thinking that . is the mode.
		//gen cluster1 = acute `r(newExpression)'
		//egen mode = mode(cluster1), min by(acute)
		gen cluster`i' = acute `r(newExpression)'
		egen mode`i' = mode(cluster`i'), maxmode by(cluster`i'), if cluster`i' > .
		display "mode: " mode`i'
		
	}
	
	display as error "EXITING EARLY FOR DEBUGGING PURPOSES"
	exit 198
	
	// TODO: Determine accuracy stats on this new dataset
	// Real macros, placeholder values. Need to assign real values.
	local truePositives = 1
	local falsePositives = 2
	local falseNegatives = 3
	local trueNegatives = 4
	
	local classifiedPositives = `truePositives' + `falsePositives'
	local classifiedNegatives = `trueNegatives' + `falseNegatives'
	
	local actualPositives = `truePositives' + `falseNegatives'
	local actualNegatives = `trueNegatives' + `falsePositives'
	
	local classifiedObservations = `actualPositives' + `actualNegatives'
	
	local sensitivityPercent = 80.947
	local specificityPercent = 81.947
	
	local positivePredictiveValuePercent = 82.947
	local negativePredictiveValuePercent = 83.947
	
	// Longest possible var name is 31 chars
	local falsePosRateForActuallyFalse = 84.947
	local falseNegRateForActuallyTrue = 85.947
	local falsePosRateForClassifiedTrue = 86.947
	local falseNegRateForClassifiedFalse = 87.947
	
	local correctlyClassifiedPercent = 88.947
	
	// Finally, print everything out (51 columns wide)
	display ""
	display "{error}NOTE: PROTOTYPE -- NOT ACTUALLY IMPLEMENTED"
	display ""
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
	
end

clear
cd "C:\Users\Mustafa\Dropbox\Classes\2016 a spring classes\Independent Study\chaid_estat_classification"
insheet using "SampleSet.csv"

// should look similar to this
//quietly logistic acute vent drips if mod(observation + 2, 9)
//estat classification if !mod(observation + 2, 9)


quietly chaid acute, ordered(vent drips) ///
			spltalpha(0.5) minnode(10) minsplit(10), ///
			if mod(observation + 2, 9), ///
			nodisp

// todo: get this to work
chaid_estat_classification if !mod(observation + 2, 9)

