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

PROC IMPORT OUT= files2.freq
            DATAFILE= "/N/slate/lisepe/Alcohol_WM/Updated_alc_variables_full.csv"
               DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

Data freq; 
set files2.freq; 

run; 

proc sql;
    create table full_alcohol2  as
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

proc sort data = full_alcohol2;
by NumZygosity;
run;

Data files2.full_alcohol2; 
set full_alcohol2; 
run;

quit; 

