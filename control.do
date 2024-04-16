* ==============================================================================
* Cleaning financial aid data for the Kessler evaluation
* Apr 16, 2024
* STEP 1-3 are omitted in this control file
* STEPS:
*    4. Create analytic sample in /4-analytic_sample/
*    5. Conduct data analysis in /5-data_analysis/
*    6. Visisualization and reporting in /6-reporting/
* REVISITED: Apr 16, 2024
* ==============================================================================




clear all
version 15.1
set more off, perm
display c(current_date)
capture putexcel clear

* Set Globals
*specify the working directory
global workdir: pwd
** Set the directory to the path established above
cd "${sd}" 

* STEP 4
* Create Analytic Sample
do "${workdir}/4-analytic_sample/code/create analytic sample.do"

copy "${workdir}/4-analytic_sample/output/financial_aid_data_student_level.dta" ///
     "${workdir}/input/", replace
	 
* STEP 5
* Conduct data analysis
	 
copy "${workdir}/modify_fa_data/output/financial_aid_data_student_year_level.dta" ///
     "./input/", replace
copy "${workdir}/merge_fa_data_with_other/output/larc_and_fa_student_year_level_panel.dta" ///
     "${workdir}/input/", replace
	 





