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
	
	// Finally, print everything out.
	display ""
	display "NOTE: PROTOTYPE -- NOT ACTUALLY IMPLEMENTED"
	display ""
	display "Decision tree model for acute" // todo: acute
	display ""
	display "              -------- True --------"
	display "Classified |         D            ~D  |      Total"
	display "-----------+--------------------------+-----------"
	display "     +     |         4             0  |          4" // todo
	display "     -     |         1             1  |          2" // todo
	display "-----------+--------------------------+-----------"
	display "   Total   |         5             1  |          6" // todo
	display ""
	display "Classified + by tree"
	display "True D defined as acute != 0" // todo: acute
	display "--------------------------------------------------"
	display "Sensitivity                     Pr( +| D)   80.00%" // todo
	display "Specificity                     Pr( -|~D)  100.00%" // todo
	display "Positive predictive value       Pr( D| +)  100.00%" // todo
	display "Negative predictive value       Pr(~D| -)   50.00%" // todo
	display "--------------------------------------------------"
	display "False + rate for true ~D        Pr( +|~D)    0.00%" // todo
	display "False - rate for true D         Pr( -| D)   20.00%" // todo
	display "False + rate for classified +   Pr(~D| +)    0.00%" // todo
	display "False - rate for classified -   Pr( D| -)   50.00%" // todo
	display "-------------------------------------------------"
	display "Correctly classified                        83.33%" // todo
	display "--------------------------------------------------"
	
end

clear
cd "C:\Users\Mustafa\Dropbox\Classes\2016 a spring classes\Independent Study\chaid_estat_classification"
insheet using "SampleSet.csv"

// todo: get this to work
chaid_estat_classification // if !mod(observation + 4, 9)
