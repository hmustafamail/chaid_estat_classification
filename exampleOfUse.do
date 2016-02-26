// Mustafa Hussain
// Spring 2016
// Example of using CHAIDESTAT

//******************************************************************************
// Setting up the environment and variables
//******************************************************************************

clear all
set more off

// Set current directory (you will have to change this)
cd "C:\Users\Mustafa\Dropbox\Classes\2016 a spring classes\Independent Study\chaid_estat_classification"

// import functions
do "generate_one_path_expression.do"
//do "chaid_estat_classification.do"

//log using outputExample,text replace

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
// Example of using CHAIDESTAT, my analogous function for CHAID tree models.
//******************************************************************************

// Create the decision tree
quietly chaid acute, ordered(vent drips nummedsquartile) ///
			spltalpha(0.5) minnode(10) minsplit(10), ///
			if mod(observation + 2, 9), ///
			nodisp

// Displaying the returned macros
display e(path1) // vent@0;nummedsquartile@1 6;
display e(path2) // vent@1;
display e(path3) // vent@0;nummedsquartile@11 15;
display e(path4) // Nothing there! TODO: how to detect?

display e(split1) // vent (0) (1)
display e(split2) // nummedsquartile (1 6) (11 15)
display e(split3) // Nothing here! TODO: how to detect?

// Displaying the returned matrix.
matrix list e(branches)

// TODO: look into function e(sample), which "marks estimation sample"

// TODO: Run on a sample set
//chaid_estat_classification if !mod(observation + 2, 9)

// Testing
// Should become: if (vent == 0) and (nummedsquartile == 1 or nummedsquartile == 6)
local path1 = e(path1)
generate_one_path_expression `"`path1'"'


//log close
