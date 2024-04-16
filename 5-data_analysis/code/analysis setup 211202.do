* ==============================================================================
* GeT Support Initial Analysis of 2021 Data
* October 26, 2021

	* imports and labels pre-survey data. 

* DATA FILES USED: 	  "$input/pre_raw data from qualtrics 210803.csv"
* DATA FILES CREATED: "$output/pre_data_clean_210803.dta

* CREATED BY: 	       Liz Jones August 3, 2021



********************************************************************************
***** SETUP WORKING DIRECTORY              	                               *****
********************************************************************************
	clear all
	
	global box  "/Users/liz/Dropbox (University of Michigan)/GeT Support/Year 4 of 5 2020_2021/5-Analysis and reporting/5-data_analysis"

	global input "$box/input"
	global output "$box/output"


********************************************************************************
***** IMPORT SURVEY DATA				      	                           *****
********************************************************************************
	use "$input/analytic_sample_complete.dta"
	
	
********************************************************************************
***** ANALYSIS				      	                           			   *****
********************************************************************************

**did their perception of overall benefit change? 
	sort name year
	bysort name: gen overall_diff=overall-overall[_n-1] if both_surveys==1
	label variable overall_diff "difference between pre and post survey responses"

	
	tab overall_diff
	
		**agreement increased for 2 people (A to SA), stayed the same for 3 (both SA), and decreased for one (A to N)
		
	**create var for change in overall perception of benefit 	
	by name: fillmissing overall_diff
	cap drop change
	gen change="Increased" if overall_diff>0
	replace change="Stayed the same" if overall_diff==0
	replace change="Decreased" if overall_diff<0
	/*lab define change 1"increase" 0"decrease" 0"stayed the same", replace
	lab values change change*/
	lab var change "amount of change in benefit rating over time"
	
**did their participation change over time?**	
	order part_other_text, after(part_not_engaged)
	egen participation=rowtotal(part_read_news-part_other)
	order participation, after(term_joined)
	lab var participation "number of activities participated in each year"

	sort name year
	bysort name: gen participation_diff=participation-participation[_n-1] 
	label variable participation_diff "difference between 2021 and 2020 responses"
	order participation_diff, after(participation)
	
		**participation increased (by 1) or stayed the same for 4 people, it decreased for 3 people
		**participation decreased by 1, 2, or 3 for each of the 3 people 
		**one of these people was not engaged at all in 2021 (this was the person for whom benefit decreased)
		
**how many people did they interact with in each year**
	recode int1* (99=0)
		**I am changing the "it's mes" to 0s because we just want to count how many other ppl they interacted with
	
	egen interaction_total=rowtotal(int1_emi-int1_mic3)
	lab var interaction_total "total number of people they interacted with (excluding themselves)"
	
	sort name year
	bysort name: gen interaction_diff=interaction_total-interaction_total[_n-1] 
	label variable interaction_diff "difference between 2021 and 2020 responses"
	order interaction_diff, after(interaction_total)
	lab var interaction_diff "diff between 2021 # of interactions and 2020 #"
		**5 people increased the number of people they interacted with, 2 people decreased**
		**the 2 people for whom int decreased were the two whose overall ben decreased or stayed the same

		
	**findings:
		**average # of people they interacted with increase: 9.3 mean in 2020, 12.6 mean in 2021
		
		
**frequency of interaction 	
	
	egen interaction_freq_total=rowtotal(int2_emi-int2_mic3)
	gen interaction_freq_mean=interaction_freq_total/interaction_total
	lab var interaction_freq_mean "mean frequency of interaction"
	drop interaction_freq_total
	
	sort name year
	bysort name: gen interaction_freq_mean_diff=interaction_freq_mean-interaction_freq_mean[_n-1] 
	lab var interaction_freq_mean_diff "difference in freq mean from 2021 to 2020"
	
	**all but one person's average frequency of interaction increased 
	
	
**what types of interactions are people having? do they change from year to year?	

		
	**create indicator vars that count each type of interaction in each year
	egen int_present = rowtotal(*_present) 
	lab var int_present "total # of presentation interactions in each year"
	
	egen int_newsletter = rowtotal(*_newsletter) 
	lab var int_newsletter "total # of newsletter interactions in each year"

	egen int_instructional = rowtotal(*_instructional) 
	lab var int_instructional "total # of instructional resource dev interactions in each year"
	
	egen int_wg_mtg = rowtotal(*_wg_mtg) 
	lab var int_wg_mtg "total # of working group interactions in each year"
	
	egen int_inperson_mtg = rowtotal(*_inperson_mtg) 
	lab var int_inperson_mtg "total # of in person mtg interactions in each year"
	
	egen int_forum = rowtotal(*_forum) 
	lab var int_forum "total # of forum interactions in each year"
	
	egen int_talk = rowtotal(*_talk) 
	lab var int_talk "total # of talk informally interactions in each year"
	
	egen int_support = rowtotal(*_support) 
	lab var int_support "total # of sought support interactions in each year"
	
	egen int_other = rowtotal(*_other) 
	lab var int_other "total # of other type of interactions in each year"
	
	
	**create var that counts whether each R had any type of interaction with at least one person in each year**
	gen int_present_ever=1 if int_present>0 
	recode int_present_ever(.=0)
	lab var int_present_ever "indicates if R interacted with at least 1 person in this way (present)"
	
	gen int_newsletter_ever=1 if int_newsletter>0 
	recode int_newsletter_ever(.=0)
	lab var int_newsletter_ever "indicates if R interacted with at least 1 person in this way (newsletter)"

	gen int_instructional_ever=1 if int_instructional>0 
	recode int_instructional_ever(.=0)	
	lab var int_instructional_ever "indicates if R interacted with at least 1 person in this way (instr resource)"

	gen int_wg_mtg_ever=1 if int_wg_mtg>0 
	recode int_wg_mtg_ever(.=0)		
	lab var int_wg_mtg_ever "indicates if R interacted with at least 1 person in this way (wg mtg)"

	gen int_inperson_mtg_ever=1 if int_inperson_mtg>0 
	recode int_inperson_mtg_ever(.=0)			
	lab var int_inperson_mtg_ever "indicates if R interacted with at least 1 person in this way (in person mtg)"
	
	gen int_forum_ever=1 if int_forum>0 
	recode int_forum_ever(.=0)				
	lab var int_forum_ever "indicates if R interacted with at least 1 person in this way (forum)"
	
	gen int_talk_ever=1 if int_talk>0 
	recode int_talk_ever(.=0)					
	lab var int_talk_ever "indicates if R interacted with at least 1 person in this way (talk informally)"
	
	gen int_support_ever=1 if int_support>0 
	recode int_support_ever(.=0)						
	lab var int_support_ever "indicates if R interacted with at least 1 person in this way (sought support)"
	
	gen int_other_ever=1 if int_other>0 
	recode int_other_ever(.=0)							
	lab var int_other_ever "indicates if R interacted with at least 1 person in this way (other)"


	
**how did people benefit from these interactions? 
	
		
	**create indicator that counts each type of benefit in each year for each person
	egen int_ben_resource = rowtotal(*ben_resource)
	lab var int_ben_resource "total # of ppl with whom R got instructional resources from"
	
	egen int_ben_think = rowtotal(*ben_think)
	lab var int_ben_think "total # of ppl that helped develop Rs thinking"
	
	egen int_ben_participate = rowtotal(*ben_participate)
	lab var int_ben_participate "total # ppl that helped R participate"
	
	egen int_ben_product = rowtotal(*ben_product)
	lab var int_ben_product "total # ppl that helped R develop written products"
	
	egen int_ben_vent = rowtotal(*ben_vent)
	lab var int_ben_vent "total # ppl that let R vent about their work"
	
	egen int_ben_advice = rowtotal(*ben_advice)
	lab var int_ben_advice "total # ppl that gave R advice"
	
	egen int_ben_other = rowtotal(*ben_other)
	lab var int_ben_other "total # ppl that R benefitted from in other ways"
	
	**create var that counts whether each R got each type of benefit from at least one person in each year**

	gen int_ben_resource_ever=1 if int_ben_resource>0 
	recode int_ben_resource_ever(.=0)	
	lab var int_ben_resource_ever "indicates if R received this benefit from at least one person (resource)"

	gen int_ben_think_ever=1 if int_ben_think>0 
	recode int_ben_think_ever(.=0)		
	lab var int_ben_think_ever "indicates if R received this benefit from at least one person (think)"

	gen int_ben_participate_ever=1 if int_ben_participate>0 
	recode int_ben_participate_ever(.=0)			
	lab var int_ben_participate_ever "indicates if R received this benefit from at least one person (participate)"

	gen int_ben_product_ever=1 if int_ben_product>0 
	recode int_ben_product_ever(.=0)				
	lab var int_ben_product_ever "indicates if R received this benefit from at least one person (product)"

	gen int_ben_vent_ever=1 if int_ben_vent>0
	recode int_ben_vent_ever(.=0)					
	lab var int_ben_vent_ever "indicates if R received this benefit from at least one person (vent)"

	gen int_ben_advice_ever=1 if int_ben_advice>0 
	recode int_ben_advice_ever(.=0)						
	lab var int_ben_advice_ever "indicates if R received this benefit from at least one person (advice)"

	gen int_ben_other_ever=1 if int_ben_other>0 
	recode int_ben_other_ever(.=0)							
	lab var int_ben_other_ever "indicates if R received this benefit from at least one person (other)"
	

**save file for visualizations in R	
save "$output/visualizations.dta", replace	

