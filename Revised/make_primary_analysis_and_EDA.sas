libname files2 "/N/slate/lisepe/Alcohol_WM";



PROC IMPORT OUT= files2.HCP_97
            DATAFILE= "/N/slate/lisepe/Alcohol_WM/HCP database 97 excel vers.csv"
               DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

PROC IMPORT OUT= files2.HCP_Behavioral 
            DATAFILE= "/N/slate/lisepe/Alcohol_WM/HCP.Behavioral.csv"
               DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

Data HCP_Behavioral; 
set files2.HCP_Behavioral; 

RUN; 

Data HCP_97_edited; 
set files2.HCP_97; 
twpair = Mother_ID;

if ZygosityGT = '' then 
	if ZygositySR = 'MZ' then NumZygosity = 1;
	else if ZygositySR = 'NotMZ' then NumZygosity = 0;
	else if ZygositySR = 'NotTwin' then delete;
	else if ZygositySR = '' then delete;  


if ZygosityGT = 'MZ' 
then NumZygosity = 1; 

if ZygosityGT = 'DZ' 
then NumZygosity = 0;

/* there is an error with this subject */ 
if Subject = 256540 then delete;
if Subject = 174437 then delete;

/* Subject 150423 has missing data and this is their twin */ 
if Subject = 150423 then delete; 
if Subject = 826353 then delete; 

RUN; 

PROC IMPORT OUT= files2.SSAGA 
            DATAFILE= "/N/slate/lisepe/Alcohol_WM/Alc_Frequencies3.csv"
               DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

Data SSAGA; 
set files2.SSAGA; 
RUN; 


PROC IMPORT OUT= files2.freq
            DATAFILE= "/N/slate/lisepe/Alcohol_WM/Factor_analysis_nomissing.csv"
               DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

Data freq; 
set files2.freq; 

run; 

PROC IMPORT OUT= files2.WM_factor
            DATAFILE= "/N/slate/lisepe/Alcohol_WM/WM_factor_scores.csv"
               DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

Data WM_factor; 
set files2.WM_factor; 

run; 


proc sql;
    create table twins_alcohol  as
    select             *     /*this asterisk tells SAS to put all of the original variables in the new data file*/
		 ,mean( Freq ) as pair_mean_Freq       
         , ( Freq - mean( Freq ) ) as pair_dev_Freq
    from HCP_97_edited left join SSAGA on HCP_97_edited.Subject = SSAGA.PUBLIC_ID
		left join HCP_Behavioral on HCP_97_edited.Subject = HCP_Behavioral.Subject
		left join freq on HCP_Behavioral.Subject = freq.Subject
		left join WM_factor on HCP_Behavioral.Subject = WM_factor.Subject
    group by twpair      /*this 'group by' tells SAS to calculate means and other values for pairs*/
    order by twpair /*twentry   /*this 'order by' just makes sure that we are still sorted as we were originally*/
    ;
quit;

%LET behavioral = WM_Task_Acc;

/* important to first sort by twpair, then other variables because that allows all of the twpairs that are missing to be dropped */  

proc sort data = twins_alcohol;
by twpair Age_in_Yrs NumZygosity &behavioral;
run;

/* sort and filter twin pairs that don't have data using deleteflags */ 

data twins_alcohol1;
set twins_alcohol;
array temp{3} t1 t2 t3(0,0,0);
if &behavioral = . and NumZygosity in (0,1)then temp(1) = twpair;
if &behavioral = . and NumZygosity in (0,1)then temp(2) = NumZygosity;
if &behavioral = . and NumZygosity in (0,1)then temp(3) = Age_in_Yrs;
if twpair = temp(1) and NumZygosity = temp(2) and Age_in_Yrs = temp(3) then deleteflag = 1;  

if deleteflag = 1 then delete;
drop t1 t2 t3 deleteflag; 
run;

%LET NIH = PicSeq_AgeAdj;

proc sort data = twins_alcohol1;
by twpair Age_in_Yrs NumZygosity &NIH;
run;


data twins_alcohol2;
set twins_alcohol1;
array temp{3} t1 t2 t3(0,0,0);
if &NIH = . and NumZygosity in (0,1)then temp(1) = twpair;
if &NIH = . and NumZygosity in (0,1)then temp(2) = NumZygosity;
if &NIH = . and NumZygosity in (0,1)then temp(3) = Age_in_Yrs;
if twpair = temp(1) and NumZygosity = temp(2) and Age_in_Yrs = temp(3) then deleteflag = 1;  

if deleteflag = 1 then delete;
drop t1 t2 t3 deleteflag; 
run;

%LET word = IWRD_TOT;

proc sort data = twins_alcohol2;
by twpair Age_in_Yrs NumZygosity &word;
run;

data twins_alcohol3;
set twins_alcohol2;
array temp{3} t1 t2 t3(0,0,0);
if &word = . and NumZygosity in (0,1)then temp(1) = twpair;
if &word = . and NumZygosity in (0,1)then temp(2) = NumZygosity;
if &word = . and NumZygosity in (0,1)then temp(3) = Age_in_Yrs;
if twpair = temp(1) and NumZygosity = temp(2) and Age_in_Yrs = temp(3) then deleteflag = 1;  

if deleteflag = 1 then delete;
drop t1 t2 t3 deleteflag; 
run;

%LET alc = Freq;

proc sort data = twins_alcohol3;
by twpair Age_in_Yrs NumZygosity &alc;
run;

data twins_alcohol4;
set twins_alcohol3;
array temp{3} t1 t2 t3(0,0,0);
if &alc = . and NumZygosity in (0,1)then temp(1) = twpair;
if &alc = . and NumZygosity in (0,1)then temp(2) = NumZygosity;
if &alc = . and NumZygosity in (0,1)then temp(3) = Age_in_Yrs;
if twpair = temp(1) and NumZygosity = temp(2) and Age_in_Yrs = temp(3) then deleteflag = 1;  

if deleteflag = 1 then delete;
drop t1 t2 t3 deleteflag; 
run;

%LET behavioral2 = WM_Task_2bk_Acc;

proc sort data = twins_alcohol4;
by twpair Age_in_Yrs NumZygosity &alc;
run;

data twins_alcohol5;
set twins_alcohol4;
array temp{3} t1 t2 t3(0,0,0);
if &behavioral2 = . and NumZygosity in (0,1)then temp(1) = twpair;
if &behavioral2 = . and NumZygosity in (0,1)then temp(2) = NumZygosity;
if &behavioral2 = . and NumZygosity in (0,1)then temp(3) = Age_in_Yrs;
if twpair = temp(1) and NumZygosity = temp(2) and Age_in_Yrs = temp(3) then deleteflag = 1;  

if deleteflag = 1 then delete;
drop t1 t2 t3 deleteflag; 
run;


proc sql;
    create table twins_alcohol6  as
    select  *,     /*this asterisk tells SAS to put all of the original variables in the new data file*/
        count(twpair) as twpair_freq
    from twins_alcohol5 
    group by twpair     
    order by twpair /*this 'order by' just makes sure that we are still sorted as we were originally*/
	;
	delete from twins_alcohol6
		where twpair_freq = 1;
quit;



proc sort data = twins_alcohol6;
by NumZygosity;
run;


proc sql;
	create table twins_alcohol7 as
    select *, (IWRD_TOT - mean(IWRD_TOT)) / std(IWRD_TOT) as IWRD_z_scores, 
    (PicSeq_AgeAdj - mean(PicSeq_AgeAdj)) / std(PicSeq_AgeAdj) as PicSeq_AgeAdj_z_scores, 
    (ListSort_AgeAdj - mean(ListSort_AgeAdj)) / std(ListSort_AgeAdj) as ListSort_AgeAdj_z_scores, 
    (WM_Task_0bk_Acc - mean(WM_Task_0bk_Acc)) / std(WM_Task_0bk_Acc) as WM_Task_0bk_Acc_z_scores, 
    (WM_Task_2bk_Acc - mean(WM_Task_2bk_Acc)) / std(WM_Task_2bk_Acc) as WM_Task_2bk_Acc_z_scores,
    (Latent_WM - mean(Latent_WM)) / std(Latent_WM) as Latent_WM_z_scores
    from twins_alcohol6;
quit;

proc corr data = twins_alcohol7; 
var IWRD_TOT IWRD_z_scores PicSeq_AgeAdj PicSeq_AgeAdj_z_scores ListSort_AgeAdj 
ListSort_AgeAdj_z_scores WM_Task_0bk_Acc WM_Task_0bk_Acc_z_scores WM_Task_2bk_Acc WM_Task_2bk_Acc_z_scores
Latent_WM  Latent_WM_z_scores; 
run; 


proc univariate data = twins_alcohol7; 
var PicSeq_AgeAdj_z_scores ListSort_AgeAdj_z_scores IWRD_z_scores WM_Task_0bk_Acc_z_scores WM_Task_2bk_Acc_z_scores; 
run; 

Data files2.twins_alcohol7; 
set twins_alcohol7; 
RUN; 

quit; 

