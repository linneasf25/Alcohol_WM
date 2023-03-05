/* assign the folder where our SAS datasets are stored as a SAS library */
libname files2 "/N/slate/lisepe/Alcohol_WM";

options nocenter;

proc univariate data = files2.twins_alcohol7; 
var Freq Total_Drinks_7days days5drinks_last12 daysdrunk_last12 daysany_last12; 
by NumZygosity;
run; 

proc univariate data = files2.twins_alcohol7; 
var Latent_WM PicSeq_AgeAdj ListSort_AgeAdj IWRD WM_Task_0bk_Acc WM_Task_2bk_Acc; 
by NumZygosity;
run; 

quit; 

