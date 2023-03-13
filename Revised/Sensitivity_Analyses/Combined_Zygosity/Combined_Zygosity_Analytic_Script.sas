/* assign the folder where our SAS datasets are stored as a SAS library */
libname files2 "/N/slate/lisepe/Alcohol_WM";
options nocenter;

/* New section without zygosity */
proc mixed data= files2.twins_alcohol7   method=ml covtest noclprint;
class twpair;
model WM_Task_0bk_Acc = pair_dev_Freq pair_mean_Freq  / solution CL alpha = .05;
random intercept / subject=twpair type=vc;
repeated / type=vc;
where NumZygosity in (0,1);
run;

/* New section without zygosity */
proc mixed data= files2.twins_alcohol7   method=ml covtest noclprint;
class twpair;
model WM_Task_0bk_Acc_z_scores = pair_dev_Freq pair_mean_Freq  / solution CL alpha = .05;
random intercept / subject=twpair type=vc;
repeated / type=vc;
where NumZygosity in (0,1);
run;

quit; 
