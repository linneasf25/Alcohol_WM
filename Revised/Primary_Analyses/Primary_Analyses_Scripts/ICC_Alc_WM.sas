/* assign the folder where our SAS datasets are stored as a SAS library */
libname files2 "/N/slate/lisepe/Alcohol_WM";

options nocenter;

***********************************************
*** General script to calculate ICC Values  ***
***********************************************;

%macro icc(out=,zyg=);
title "ICC, &out, zygo=&zyg";
ods output CovParms = covp_&zyg._&out;
proc mixed data = files2.twins_alcohol7 noclprint;
   class twpair;
   model &out = ;
   random intercept /Subject=twpair;
   where NumZygosity = &zyg;
run;


proc sql;
  create table ICC as
  select Subject, Estimate/sum(Estimate) as icc_zyg&zyg._&out
  from covp_&zyg._&out
 ;
select icc_zyg&zyg._&out from ICC where subject = "twpair"
  ;
quit;

%mend icc;

***********************************************
*** Calculate Alcohol ICC Values  ***
*** ZYG 0 is DZ twins, ZYG 1 is MZ twins ***
***********************************************;


/* Frequency of Alcohol Use */ 

%icc(out=Freq, zyg=0); 
%icc(out=Freq, zyg=1);

/* Frequency of Alcohol Use */ 

%icc(out=Freq, zyg=0); 
%icc(out=Freq, zyg=1);

/* Total drinks over 7 days */ 

%icc(out=Total_Drinks_7days, zyg=0); 
%icc(out=Total_Drinks_7days, zyg=1);

/* Number of days with at least 5 drinks in the past year */ 

%icc(out=days5drinks_last12, zyg=0); 
%icc(out=days5drinks_last12, zyg=1);

/* Number of drunk days in the past year */ 

%icc(out=daysdrunk_last12, zyg=0); 
%icc(out=daysdrunk_last12, zyg=1);

/* Number of days with any drinks in the past year */ 

%icc(out=daysany_last12, zyg=0); 
%icc(out=daysany_last12, zyg=1);


***********************************************
*** Calculate Working Memory ICC Values  ***
*** ZYG 0 is DZ twins, ZYG 1 is MZ twins ***
***********************************************;

/* Latent WM Score */ 

%icc(out=Latent_WM, zyg=0); 
%icc(out=Latent_WM, zyg=1);

/* Picture Sequence */ 

%icc(out=PicSeq_AgeAdj, zyg=0); 
%icc(out=PicSeq_AgeAdj, zyg=1);

/* Penn Word Memory */ 

%icc(out=IWRD, zyg=0); 
%icc(out=IWRD, zyg=1);

/* List Sorting Task */ 

%icc(out=ListSort_AgeAdj, zyg=0); 
%icc(out=ListSort_AgeAdj, zyg=1);

/* 2-Back */ 

%icc(out=WM_Task_2bk_Acc, zyg=0); 
%icc(out=WM_Task_2bk_Acc, zyg=1);


quit; 
