// Mustafa Hussain
// Spring 2016
// Building the Tree Classifiers

clear

// import data
cd "C:\Users\Mustafa\Dropbox\Classes\2016 a spring classes\Independent Study"

set more off

quietly do "CoreStats"

//**********************************************************
// Building the Trees
//**********************************************************

// todo: test decision trees classification with same variables.
// ssc install chaid
// ssc install moremata

set seed 1 // recommended, because random.
gen str16 filename = "trees\" + string(0) + ".png"

program drop myprogram
program myprogram
	forvalues i = 0 1 to 8{
		chaid acute, ordered(vent drips nummedsquartile) ///
			spltalpha(0.5) minnode(10) minsplit(10), ///
			if mod(observation + `i', 9)
		
		//replace filename = "trees\" + string(i) + ".png"
		display `i'
		graph export "tree`i'.png", as(png) replace
	}
end

myprogram

exit


//chaid acute, ordered(vent drips nummedsquartile) spltalpha(0.5) minnode(10) minsplit(10), if mod(observation, 4)


