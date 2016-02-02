// Mustafa Hussain
// Spring 2016
// CHAIDESTAT - Postestimation classifier accuracy metrics for CHAID
// Written for STATA 13

// command prototype
// chaidestat classification if !mod(observation + 4, 9)

capture program drop chaid_estat_classification
program define chaid_estat_classification
*! Postestimation classifier accuracy metrics for CHAID v1 GR 2-Feb-16
	version 13.0
	syntax [if]
	
	// todo: check if placeholder is "classification," complain and exit if not.
	//if `1' != "classification"{
	//	display as error `Usage: chaidestat classification [if <condition>]'
	//	exit 198
	//}
	
	display "hooray!"
	
	// not doing anything yet
	
end

clear
cd "C:\Users\Mustafa\Dropbox\Classes\2016 a spring classes\Independent Study\chaidestat\"
insheet using "SampleSet.csv"

// todo: get this to work
chaid_estat_classification
