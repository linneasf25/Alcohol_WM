
*** calculate ICCS ***;
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

/* Frequency of Alcohol Use */ 

%icc(out=Freq, zyg=0); 
%icc(out=Freq, zyg=1);
