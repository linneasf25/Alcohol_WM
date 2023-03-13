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

Data HCP_97_edited_full; 
set files2.HCP_97; 
twpair = Mother_ID;

if ZygosityGT = '' then 
	if ZygositySR = 'MZ' then NumZygosity = 1;
	else if ZygositySR = 'NotMZ' then NumZygosity = 0;

if ZygosityGT = 'MZ' then NumZygosity = 1;

else if ZygosityGT = 'DZ' then NumZygosity = 0;

else NumZygosity = 2; 


RUN; 

PROC IMPORT OUT= files2.SSAGA 
            DATAFILE= "/N/slate/lisepe/Alcohol_WM/Alc_Frequencies3.csv"
               DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

Data SSAGA; 
set files2.SSAGA; 
RUN; 


run; 

PROC IMPORT OUT= files2.freq
            DATAFILE= "/N/slate/lisepe/Alcohol_WM/Updated_alc_variables_full.csv"
               DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

Data freq; 
set files2.freq; 

run; 

proc sql;
    create table full_alcohol  as
    select             *     /*this asterisk tells SAS to put all of the original variables in the new data file*/
		 ,mean( Freq ) as pair_mean_Freq       
         , ( Freq - mean( Freq ) ) as pair_dev_Freq
    from HCP_97_edited_full left join SSAGA on HCP_97_edited_full.Subject = SSAGA.PUBLIC_ID
		left join HCP_Behavioral on HCP_97_edited_full.Subject = HCP_Behavioral.Subject
		left join freq on HCP_Behavioral.Subject = freq.PUBLIC_ID
    group by twpair      /*this 'group by' tells SAS to calculate means and other values for pairs*/
    order by twpair /*twentry   /*this 'order by' just makes sure that we are still sorted as we were originally*/
    ;
quit;


proc sort data = full_alcohol;
by NumZygosity;
run;


proc sql;
	create table full_alcohol2 as
    select *, IWRD_TOT, (IWRD_TOT - mean(IWRD_TOT)) / std(IWRD_TOT) as IWRD_z_scores, 
    PicSeq_AgeAdj, (PicSeq_AgeAdj - mean(PicSeq_AgeAdj)) / std(PicSeq_AgeAdj) as PicSeq_AgeAdj_z_scores, 
    ListSort_AgeAdj, (ListSort_AgeAdj - mean(ListSort_AgeAdj)) / std(ListSort_AgeAdj) as ListSort_AgeAdj_z_scores, 
    WM_Task_0bk_Acc, (WM_Task_0bk_Acc - mean(WM_Task_0bk_Acc)) / std(WM_Task_0bk_Acc) as WM_Task_0bk_Acc_z_scores, 
    WM_Task_2bk_Acc, (WM_Task_2bk_Acc - mean(WM_Task_2bk_Acc)) / std(WM_Task_2bk_Acc) as WM_Task_2bk_Acc_z_scores
    from full_alcohol;
quit;


proc corr data = full_alcohol2; 
var IWRD_TOT IWRD_z_scores PicSeq_AgeAdj PicSeq_AgeAdj_z_scores ListSort_AgeAdj 
ListSort_AgeAdj_z_scores WM_Task_0bk_Acc WM_Task_0bk_Acc_z_scores WM_Task_2bk_Acc WM_Task_2bk_Acc_z_scores; 
run; 

Data files2.full_alcohol2; 
set full_alcohol2; 
RUN;

quit; 

