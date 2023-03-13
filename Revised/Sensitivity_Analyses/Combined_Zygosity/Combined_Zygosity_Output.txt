The SAS System                                                                              Monday, January  2, 2023 09:16:00 PM   1

The Mixed Procedure

                  Model Information

Data Set                     FILES2.TWINS_ALCOHOL7    
Dependent Variable           WM_Task_0bk_Acc          
Covariance Structure         Variance Components      
Subject Effect               twpair                   
Estimation Method            ML                       
Residual Variance Method     Parameter                
Fixed Effects SE Method      Model-Based              
Degrees of Freedom Method    Containment              


            Dimensions

Covariance Parameters             2
Columns in X                      3
Columns in Z per Subject          1
Subjects                        218
Max Obs per Subject               2


          Number of Observations

Number of Observations Read             436
Number of Observations Used             436
Number of Observations Not Used           0


                     Iteration History
 
Iteration    Evaluations        -2 Log Like       Criterion

        0              1      3216.48730119                
        1              1      3208.35266712      0.00000000


                   Convergence criteria met.                    


                  Covariance Parameter Estimates
 
                                     Standard         Z
Cov Parm      Subject    Estimate       Error     Value      Pr > Z

Intercept     twpair      17.9198      6.4567      2.78      0.0028
Residual                  75.7136      7.2521     10.44      <.0001


           Fit Statistics

-2 Log Likelihood              3208.4
AIC (Smaller is Better)        3218.4
AICC (Smaller is Better)       3218.5
BIC (Smaller is Better)        3235.3
The SAS System                                                                              Monday, January  2, 2023 09:16:00 PM   2

The Mixed Procedure

                                      Solution for Fixed Effects
 
                              Standard
Effect            Estimate       Error      DF    t Value    Pr > |t|     Alpha       Lower       Upper

Intercept          90.3332      0.5058     216     178.59      <.0001      0.05     89.3362     91.3302
pair_dev_Freq       0.7013      1.0643     217       0.66      0.5107      0.05     -1.3965      2.7990
pair_mean_Freq      1.6131      0.5975     217       2.70      0.0075      0.05      0.4353      2.7908


           Type 3 Tests of Fixed Effects
 
                   Num     Den
Effect              DF      DF    F Value    Pr > F

pair_dev_Freq        1     217       0.43    0.5107
pair_mean_Freq       1     217       7.29    0.0075
The SAS System                                                                              Monday, January  2, 2023 09:16:00 PM   3

The Mixed Procedure

                  Model Information

Data Set                     FILES2.TWINS_ALCOHOL7    
Dependent Variable           WM_Task_0bk_Acc_z_scores 
Covariance Structure         Variance Components      
Subject Effect               twpair                   
Estimation Method            ML                       
Residual Variance Method     Parameter                
Fixed Effects SE Method      Model-Based              
Degrees of Freedom Method    Containment              


            Dimensions

Covariance Parameters             2
Columns in X                      3
Columns in Z per Subject          1
Subjects                        218
Max Obs per Subject               2


          Number of Observations

Number of Observations Read             436
Number of Observations Used             436
Number of Observations Not Used           0


                     Iteration History
 
Iteration    Evaluations        -2 Log Like       Criterion

        0              1      1227.37259074                
        1              1      1219.23795666      0.00000000


                   Convergence criteria met.                    


                  Covariance Parameter Estimates
 
                                     Standard         Z
Cov Parm      Subject    Estimate       Error     Value      Pr > Z

Intercept     twpair       0.1871     0.06740      2.78      0.0028
Residual                   0.7904     0.07571     10.44      <.0001


           Fit Statistics

-2 Log Likelihood              1219.2
AIC (Smaller is Better)        1229.2
AICC (Smaller is Better)       1229.4
BIC (Smaller is Better)        1246.2
The SAS System                                                                              Monday, January  2, 2023 09:16:00 PM   4

The Mixed Procedure

                                      Solution for Fixed Effects
 
                              Standard
Effect            Estimate       Error      DF    t Value    Pr > |t|     Alpha       Lower       Upper

Intercept         7.56E-13     0.05168     216       0.00      1.0000      0.05     -0.1019      0.1019
pair_dev_Freq      0.07165      0.1087     217       0.66      0.5107      0.05     -0.1427      0.2860
pair_mean_Freq      0.1648     0.06105     217       2.70      0.0075      0.05     0.04448      0.2851


           Type 3 Tests of Fixed Effects
 
                   Num     Den
Effect              DF      DF    F Value    Pr > F

pair_dev_Freq        1     217       0.43    0.5107
pair_mean_Freq       1     217       7.29    0.0075
