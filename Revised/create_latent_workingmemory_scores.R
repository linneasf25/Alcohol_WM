rm(list = ls())
cat("\014") 

#------------------------------------------------------------
# Packages
#------------------------------------------------

install.packages("dbplyr", repos="http://cran.rstudio.com/", dependencies=TRUE)
install.packages("dplyr", repos="http://cran.rstudio.com/", dependencies=TRUE)
install.packages("cli", repos="http://cran.rstudio.com/", dependencies=TRUE)
install.packages("tidyr", repos="http://cran.rstudio.com/", dependencies=TRUE)
install.packages("ggplot2", repos="http://cran.rstudio.com/", dependencies=TRUE)
install.packages("ggpubr", repos="http://cran.rstudio.com/", dependencies=TRUE)
install.packages("lavaan", repos="http://cran.rstudio.com/", dependencies=TRUE)
install.packages("semPlot", repos="http://cran.rstudio.com/", dependencies=TRUE)
library(psych)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpubr)


# Packages for CFA
library(lavaan)
install.packages("semPlot")
library(semPlot)


#----------------------------------------------------------------------------------------
#  Load in Data

#-----------------------------------------------------------------------------------------
df <- read.csv("WM_Tasks.csv")

typeof(df$PicSeq_AgeAdj)
typeof(df$IWRD_TOT)
typeof(df$ListSort_AgeAdj)
typeof(df$WM_Task_2bk_Acc)


sum(is.na(df)) # no missing data

df <- na.omit(df)

sum(is.na(df))

df$PicSeq_AgeAdj <- as.numeric(df$PicSeq_AgeAdj)
df$IWRD_TOT <- as.numeric(df$IWRD_TOT)
df$WM_Task_2bk_Acc <- as.numeric(df$WM_Task_2bk_Acc)
df$ListSort_AgeAdj <- as.numeric(df$ListSort_AgeAdj)

str(df)

describe(df)

hist(df$PicSeq_AgeAdj)
hist(df$IWRD_TOT)
hist(df$WM_Task_2bk_Acc)
hist(df$ListSort_AgeAdj)

df[ , c(3:6)] <- df[ , c(3:6)] %>% scale()
#------------------------------------------------------------
#  CFA script
#------------------------------------------------------------

# Create text string describing model
### Look at lavaan sytax for more info "=~" denotes what are indicators of what factor


WM_mod <- 'WM =~ PicSeq_AgeAdj + IWRD_TOT + WM_Task_2bk_Acc + ListSort_AgeAdj'

correlation = cor(df[,3:6], method = "spearman") %>% round(2)

# Run CFA model
WM_fit <- cfa(WM_mod , # model to be run (text file)
               data= df, # data 
               estimator = "MLR", # Robust ML estimator for skewed data (like symptom counts)
               std.lv = T,# asks for standardized parameters (most common CFA presentation)
               cluster = "Mother_ID") 

varTable(WM_fit)

# Plot model
semPaths(WM_fit, # CFA model
         title = F, 
         what = "std", # print standardized factor loadings
         intercepts = F, 
         residuals = F, 
         layout = "tree2", # layout of figures
         edge.label.cex = .8)

# Note: CFI is the Comparative Fit Index – values can range between 0 and 1 (values greater than 0.90, conservatively 0.95 indicate good fit)
#CFA Summary 

### Provides ALOT of information
summary(WM_fit, 
        standardized= TRUE, # standardize parameters
        fit.measure = TRUE) # fit measures in 


# Pull out fitmeasures you want
## create list of stats to pull out
fit.stats <- c("npar", # number of parameters
               "chisq.scaled", # chi-square stat
               "df.scaled", # chi degrees of freedom
               "pvalue.scaled", # chi squared p-value
               "cfi.robust", 
               "BIC", 
               "rmsea.robust") 

# look at fit statistics
fitmeasures(WM_fit,
            fit.measures = fit.stats)



mod_ind <- modificationindices(WM_fit)
head(mod_ind[order(mod_ind$mi, decreasing = T),], 20) # computes MI and ranks sources of misfit
# results show residual relationship between Sed_Sx and Op_Sx is largest source of misfit
## model already fits well so no additional changes are needed based on MI


#
Fscores  <- lavPredict(WM_fit , 
                       type = "lv", # standardized fscores
                       method = "EBM") %>%  # how to calculate scores, look at lavaan manual for what method is best for your model
  as.data.frame()

df1 <- cbind(df, Fscores)

#------------------------------------------------------------
#  Pulling out paramaters you want (many time to make tables)
#------------------------------------------------------------
# lavInspect "pulls" out the elements you specify

# this pulls out standardized parameters
lavInspect(WM_fit,
           what = "std")

# this pulls out standardized factor loadings specifically
lavInspect(WM_fit,
           what = "std")$lambda

write.csv(df1,"WM_factor_scores.csv", row.names = FALSE)
