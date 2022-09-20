/* Demographics */

proc freq data = twins_alcohol6; 
tables Race Ethnicity SSAGA_Income SSAGA_Educ NumZygosity Gender; 
run; 

proc univariate data = twins_alcohol6; 
var Age_in_Yrs; 
run; 


/* Model 1 picture sequence */ 

proc mixed data= twins_alcohol6 method=ml covtest noclprint;
class twpair NumZygosity;
model PicSeq_AgeAdj = Freq / solution CL alpha = .01;
random intercept / subject=twpair type=vc;
repeated / group=NumZygosity type=vc;
where NumZygosity in (1,0);
run;

/* Model 1 - IWRD_TOT */

proc mixed data= twins_alcohol6 method=ml covtest noclprint;
class twpair NumZygosity;
model IWRD_TOT = Freq / solution CL alpha = .01;
random intercept / subject=twpair type=vc;
repeated / group=NumZygosity type=vc;
where NumZygosity in (1,0);
run;

/* Model 1 - ListSort_AgeAdj */

proc mixed data= twins_alcohol6 method=reml covtest noclprint;
class twpair NumZygosity;
model ListSort_AgeAdj = Freq / solution CL alpha = .01;
random intercept / subject=twpair type=vc;
repeated / group=NumZygosity type=vc;
where NumZygosity in (1,0);
run;



/* Model 1 - 0-back overall  */

proc mixed data= twins_alcohol6 method=ml covtest noclprint;
class twpair NumZygosity;
model WM_Task_0bk_Acc = Freq / solution CL alpha = .01;
random intercept / subject=twpair type=vc;
repeated / group=NumZygosity type=vc;
where NumZygosity in (0,1);
run;


/* Model 1 - 2-back overall */ 
proc mixed data= twins_alcohol6 method=ml covtest noclprint;
class twpair NumZygosity;
model WM_Task_2bk_Acc = Freq / solution CL alpha = .01;
random intercept / subject=twpair group = NumZygosity type=vc;
repeated / group=NumZygosity type=vc;
where NumZygosity in (0,1);
run;


/* Model 4 0-back */ 

proc mixed data= twins_alcohol6   method=ml covtest noclprint;
class twpair NumZygosity;
model WM_Task_0bk_Acc = pair_dev_Freq pair_mean_Freq pair_dev_Freq*NumZygosity  / solution CL alpha = .01;
random intercept / subject=twpair group = NumZygosity type=vc;
repeated / group=NumZygosity type=vc;
where NumZygosity in (0,1);
run;

