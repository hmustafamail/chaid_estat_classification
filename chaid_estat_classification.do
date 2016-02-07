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
	
	// TODO: Grab all the stuff from CHAID's return registers
	
	// TODO: Parse IF to generate new dataset
	
	// TODO: Classify this new dataset based on the tree
	
	// TODO: Determine accuracy stats on this new dataset
	
	// TODO: Finally, print everything out (51 columns wide)
	
	display ""
	display "{error}NOTE: PROTOTYPE -- NOT ACTUALLY IMPLEMENTED"
	display ""
	display "{txt}{title:Decision tree model for acute}" // todo: acute
	display ""
	display "{ralign 36:{hline 8} True {hline 8}}"
	display "Classified {c |}{ralign 10: D}{dup 3: }{ralign 11: ~D}{dup 2: }{c |}{ralign 11: Total}"
	display "{hline 11}{c +}{hline 26}{c +}{hline 11}"	
	display "{center 11: +}{c |}{ralign 10: 4}{dup 3: }{ralign 11: 0}{dup 2: }{c |}{ralign 11: 4}" // todo
	display "{center 11: -}{c |}{ralign 10: 1}{dup 3: }{ralign 11: 1}{dup 2: }{c |}{ralign 11: 2}" // todo
	display "{hline 11}{c +}{hline 26}{c +}{hline 11}"	
	display "{center 11: Total}{c |}{ralign 10: 5}{dup 3: }{ralign 11: 1}{dup 2: }{c |}{ralign 11: 6}" // todo
	display ""
	display "Classified by tree"
	display "True D defined as acute != 0" // todo: acute
	display "{hline 50}"
	display "{lalign 32:Sensitivity}Pr( +| D){ralign 9:80.00%}" // todo
	display "{lalign 32:Specificity}Pr( -|~D){ralign 9:100.00%}" // todo
	display "{lalign 32:Positive predictive value}Pr( D| +){ralign 9:100.00%}" // todo
	display "{lalign 32:Negative predictive value}Pr(~D| -){ralign 9:50.00%}" // todo
	display "{hline 50}"
	display "{lalign 32:False + rate for true ~D}Pr( +|~D){ralign 9:0.00%}" // todo
	display "{lalign 32:False - rate for true D}Pr( -| D){ralign 9:20.00%}" // todo
	display "{lalign 32:False + rate for classified +}Pr(~D| +){ralign 9:0.00%}" // todo
	display "{lalign 32:False - rate for classified -}Pr( D| -){ralign 9:50.00%}" // todo
	display "{hline 50}"
	display "Correctly classified{ralign 30:83.33%}" // todo
	display "{hline 50}"
	
end

clear
cd "C:\Users\Mustafa\Dropbox\Classes\2016 a spring classes\Independent Study\chaid_estat_classification"
insheet using "SampleSet.csv"

// should look similar to this
quietly logistic acute vent drips if mod(observation + 4, 9)
estat classification if !mod(observation + 4, 9)


// todo: get this to work
chaid_estat_classification // if !mod(observation + 4, 9)

