// Mustafa Hussain
// Spring 2016
// Testing the Tree Classifiers

clear

// import data and generate variables
cd "C:\Users\Mustafa\Dropbox\Classes\2016 a spring classes\Independent Study"
set more off
quietly do "CoreStats"

// todo: test decision trees classification with same variables.
// ssc install chaid
// ssc install moremata

gen numberCorrectlyClassified = -1
gen accuracy = -1
gen sampleSize = -1

capture program drop myprogram
program myprogram
	forvalues i = 0 1 to 8{
	
		// This is the line to copypaste from below
		quietly count if ((vent | ((nummedsquartile > 5) & drips)) == acute) & !mod(observation + `i', 9)
		
		quietly replace numberCorrectlyClassified = r(N)
		
		quietly count if !mod(observation + `i', 9)
		quietly replace sampleSize = r(N)
		
		quietly replace accuracy = numberCorrectlyClassified / sampleSize
		display accuracy
		
	}
end

myprogram
exit

// These are the "trees." Copy and paste into the loop one at a time.

// Tree A
quietly count if vent == acute

// Tree B (the pipe, | means "or")
quietly count if ((vent | drips) == acute) & !mod(observation + `i', 9)

// Tree C(vent or top 50% of nummeds)
quietly count if ((vent | (nummedsquartile > 10)) == acute) & !mod(observation + `i', 9)

// Tree D(vent or top 75% of nummeds)
quietly count if ((vent | (nummedsquartile > 5)) == acute) & !mod(observation + `i', 9)

// Tree E(the ampersand, &, means "and")
quietly count if ((vent | ((nummedsquartile > 5) & drips)) == acute) & !mod(observation + `i', 9)
