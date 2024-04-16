* ==============================================================================
* Cleaning financial aid data for the Kessler evaluation
* Apr 16, 2024
*
*
* CREATED BY: 	       Liz Jones November 13, 2021
* ==============================================================================




clear all
version 15.1
set more off, perm
display c(current_date)
capture putexcel clear

* Set Globals
*specify the working directory
global sd "~/Box/Kessler-FinAid/analyze_descriptives/"
** Set the directory to the path established above
cd "${sd}" 

* STEP 4
* Create Analytic Sample
do "./4-analytic_sample/code/create analytic sample.do"

copy "./4-analytic_sample/output/financial_aid_data_student_level.dta" ///
     "./input/", replace
	 
* STEP 4
* Run student level financial aid descriptives
	 
copy "../modify_fa_data/output/financial_aid_data_student_year_level.dta" ///
     "./input/", replace
copy "../merge_fa_data_with_other/output/larc_and_fa_student_year_level_panel.dta" ///
     "./input/", replace
	 





