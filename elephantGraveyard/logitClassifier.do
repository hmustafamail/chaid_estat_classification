// Mustafa Hussain
// Spring 2016
// Runs several logit classifiers on the data, saves results of classifications.

clear

// import data
cd "C:\Users\Mustafa\Dropbox\Classes\2016 a spring classes\Independent Study"

quietly do "CoreStats"

set more off

//log using logitResults,text replace

//**********************************************************
// Logistics
//**********************************************************

program drop myprogram
program myprogram
	forvalues i = 0 1 to 8{
		
		// Replace with the below commands and run one at a time
		quietly logistic acute vent drips nummedsquartile if mod(observation + `i', 9)
		quietly estat classification if !mod(observation + `i', 9)
		
		display r(P_corr)
	}
end

myprogram

exit

//  Logit with one-clever-cue.
logistic acute vent

//  Logit with the two very best.
logistic acute vent drips

//  Logit with the other two very best.
logistic acute vent nummedsquartile

//  Logit with all possible variables.
logistic acute vent drips nummedsquartile

// todo: test decision trees classification with same variables.
// ssc install chaid
// ssc install moremata
//set seed 1 // recommended, because random.

// todo: these are really liberal settings.
//chaid acute, ordered(vent drips nummedsquartile) spltalpha(0.5) minnode(10) minsplit(10), if mod(observation, 4)

// If here, no errors!
//log close

