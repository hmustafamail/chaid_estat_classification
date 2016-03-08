// Mustafa Hussain
// Spring 2016
// Smaller example of use
// Written for STATA 13

set more off

do "chaid_estat_classification.do"

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

// TODO: writing this function
chaid_estat_classification if !mod(observation + 2, 9)
