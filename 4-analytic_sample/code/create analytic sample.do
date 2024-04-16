* ==============================================================================
* GeT Support - create analytic sample
* October 26, 2021

	* Restricts sample to only those who completed the survey in 2020 and 2021

* DATA FILES USED: 	  "use "$input/participant_survey.dta"
* DATA FILES CREATED: "$output/analyic_sample.dta"

* CREATED BY: 	       Liz Jones November 13, 2021

********************************************************************************
***** SETUP WORKING DIRECTORY              	                               *****
********************************************************************************
	clear all
	
	global box  "/Users/liz/Dropbox (University of Michigan)/GeT Support/Year 4 of 5 2020_2021/5-Analysis and reporting/4-analytic_sample"

	global input "$box/input"
	global output "$box/output"


********************************************************************************
***** IMPORT SURVEY DATA				      	                           *****
********************************************************************************
	use "$input/participant_survey.dta"
	**it's best to use the .dta file that came from the stata append because it has all the var labels 
	
	
********************************************************************************
***** PREP 							      	                           *****
********************************************************************************
**create var that indicates participation in both surveys**
	bysort name: gen rows=_n
	order rows, after(name)
	gen both_surveys=1 if rows==2
	bysort name: fillmissing both_surveys
	order both_surveys, after(name)
	drop rows
	
	**7 respondents who completed both surveys**
	**TA, SC, NM, RS, RS, JS, SV
	
********************************************************************************
***** ANALYSIS						      	                               *****
********************************************************************************
	
	keep if both_surveys==1

save "$output/analytic_sample_partial.dta", replace

	drop if name=="Co" 
	
save "$output/analytic_sample_complete.dta", replace
