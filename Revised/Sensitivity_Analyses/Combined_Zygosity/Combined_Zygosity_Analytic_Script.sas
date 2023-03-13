/* assign the folder where our SAS datasets are stored as a SAS library */
libname files2 "/N/slate/lisepe/Alcohol_WM";

options nocenter;

***********************************************
*** Macro(function) to run mixed models for different WM or attention tests ***
***********************************************;
	
%macro run_mixedmodel_for_class(class_name); 
	title "Model 4 association of alcohol score with &class_name"; 
	proc mixed data= files2.twins_alcohol7 method=ml covtest noclprint; 
		class twpair NumZygosity;
		model &class_name = pair_dev_Freq pair_mean_Freq / solution CL alpha = .05;
		random intercept / group = NumZygosity subject=twpair type=vc;
		repeated / group=NumZygosity type=vc;
		where NumZygosity in (1,0);
	run;
	
%mend run_mixedmodel_for_class;

***********************************************
*** Iterate through each class and run the run_logistic_for_class macro for each one ***
*** variable next_class holds the class logistic needs to be run for ***
***********************************************;


%macro loop_over_classes(class_list); 

	%local i next_class; 
	%let i = 1; 
	%do %while (%scan(&class_list, &i) ne);
		%let next_class = %scan(&class_list, &i); 
		%run_mixedmodel_for_class(&next_class);
		%let i = %eval(&i + 1); 
	%end;

%mend loop_over_classes;

***********************************************
*** Define a list of classes that we need to run logistic for and loop over the list ***
***********************************************;

%let class_list = ListSort_AgeAdj_z_scores IWRD_z_scores PicSeq_AgeAdj_z_scores 
WM_Task_2bk_Acc_z_scores Latent_WM;
%loop_over_classes(class_list = &class_list);
