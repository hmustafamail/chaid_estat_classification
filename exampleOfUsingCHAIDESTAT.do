// Mustafa Hussain
// Spring 2016
// Example of using CHAIDESTAT

//******************************************************************************
// Setting up the environment and variables
//******************************************************************************

clear
set more off

// Set current directory (you will have to change this)
cd "C:\Users\Mustafa\Dropbox\Classes\2016 a spring classes\Independent Study\chaidestat"

log using outputExample,text replace

// Import data
insheet using "SampleSet.csv"

// Split up nummeds into quartiles
egen nummedsquartile = cut(nummeds), at(1, 6, 11, 15, 29)

//******************************************************************************
// Example of using ESTAT, the precedent for logit models.
//******************************************************************************

// Create logistic model
logistic acute vent drips nummedsquartile if mod(observation + 4, 9)

// Run on a sample set
estat classification if !mod(observation + 4, 9)

//******************************************************************************
// Example of using CHAIDESTAT, an analogous function for CHAID tree models.
//******************************************************************************

// Create the decision tree
chaid acute, ordered(vent drips nummedsquartile) ///
			spltalpha(0.5) minnode(10) minsplit(10), ///
			if mod(observation + 4, 9)

// TODO: Run on a sample set
// chaidestat classification if !mod(observation + 4, 9)

log close
