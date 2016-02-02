// Mustafa Hussain
// Spring 2016
// Compares Logit with Tree Classifier

// This is NOT the way I would like to do it. The goal of the current project 
// is to create a function that tests a CHAID tree on a preclassified dataset 
// and outputs accuracy statistics: 
//  1. Overall accuracy percentage
//  2. Sensitivity
//  3. Specificity

// This is here so that we can validate the results of the automated evaluator
// against these manually created results.

clear

// import data
cd "C:\Users\Mustafa\Dropbox\Classes\2016 a spring classes\Independent Study"

insheet using "ClassifierAccuracies.csv"

set more off

log using comparingClassifiers,text replace

// Compare tree with logit models
ranksum vent, by(logit0tree1)
ranksum ventdrips, by(logit0tree1)
ranksum ventmeds, by(logit0tree1)
ranksum ventdripsmeds, by(logit0tree1)

// Compare each with baseline.
ttest vent == 57.41 if logit0tree1 == 0
ttest ventdrips == 57.41 if logit0tree1 == 0
ttest ventmeds == 57.41 if logit0tree1 == 0
ttest ventdripsmeds == 57.41 if logit0tree1 == 0

ttest vent == 57.41 if logit0tree1 == 1
ttest ventdrips == 57.41 if logit0tree1 == 1
ttest ventmeds == 57.41 if logit0tree1 == 1
ttest ventdripsmeds == 57.41 if logit0tree1 == 1

log close
