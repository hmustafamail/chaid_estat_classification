// Mustafa Hussain
// Spring 2016
// Smaller example of use
// Written for STATA 13

// Set up environment
set more off
clear all
cd "C:\Users\Mustafa\Dropbox\Classes\2016 a spring classes\Independent Study\chaid_estat_classification"
insheet using "SampleSet.csv"

// Import the function
do "chaid_estat_classification.do"

// Run CHAID
quietly chaid acute, ordered(vent drips) ///
			spltalpha(0.5) minnode(10) minsplit(10), ///
			if mod(observation + 2, 9), ///
			nodisp

// Get classification accuracy on a particular subset of the data.
chaid_estat_classification if !mod(observation + 2, 9)
