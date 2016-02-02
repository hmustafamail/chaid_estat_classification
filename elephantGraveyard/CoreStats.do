// Mustafa Hussain
// Spring 2016

clear

// import data
cd "C:\Users\Mustafa\Dropbox\Classes\2016 a spring classes\Independent Study"
insheet using "SampleSet.csv"

// log using output,text replace

//**********************************************************
// Predicting Acuity
//**********************************************************

// Show the percentiles
tabulate acuity

// Do nurses reliably know who is the most acute in the unit? Yes.
ologit mostacute iddbyothers

// This gives probability of not being most acute.
margins, at(iddbyothers=(0(1)4)) vsquish

// Split up nummeds into quartiles
tabulate nummeds
egen nummedsquartile = cut(nummeds), at(1, 6, 11, 15, 29)

// See effect of all on acute
logistic acute vent drips nummedsquartile numwatches 

// If here, no errors!
// log close
