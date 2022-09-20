rm(list = ls())
cat("\014") 

#------------------------------------------------------------
# Packages
#------------------------------------------------------------
library(psych)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpubr)


# Packages for CFA
library(lavaan)
library(semPlot)


#----------------------------------------------------------------------------------------
#  Load in Data
### Data consists of 6 variables: SubID, 
### and 5 symptom count variables, Cannabis, Stimulant, Sedative, Opiates, Other
#-----------------------------------------------------------------------------------------
df <- read.csv("newfactor_cluster.csv")

typeof(df$Total_Drinks_7days)
typeof(df$Num_Days_Drank_7days)


df$DrinksTypicalDay[is.na(df$DrinksTypicalDay)] <- 0

sum(is.na(df)) # no missing data

df <- na.omit(df)

sum(is.na(df))

df$Total_Drinks_7days <- as.numeric(df$Total_Drinks_7days) 
df$Num_Days_Drank_7days <- as.numeric(df$Num_Days_Drank_7days) 

str(df)

describe(df)
# All symptom counts are highly skewed
hist(df$Total_Drinks_7days)
hist(df$Num_Days_Drank_7days)
hist(df$days5drinks_last12)
hist(df$daysdrunk_last12)
hist(df$daysany_last12)

#why is this being weird? 
hist(df$DrinksTypicalDay)

df[ , c(2:8)] <- df[ , c(2:8)] %>% scale()
#------------------------------------------------------------
#  CFA script
#------------------------------------------------------------

# Create text string describing model
### Look at lavaan sytax for more info "=~" denotes what are indicators of what factor
### Below syntax can be read: the "SUD" factor (SUD is abitrary label) is measured by all 5 symptom counts

Freq_mod <- 'Freq =~ Total_Drinks_7days + days5drinks_last12 + daysdrunk_last12 + daysany_last12'

correlation = cor(df[,2:6], method = "spearman") %>% round(2)

# Run CFA model
Freq_fit <- cfa(Freq_mod , # model to be run (text file)
               data= df, # data 
               estimator = "MLR", # Robust ML estimator for skewed data (like symptom counts)
               std.lv = T,# asks for standardized parameters (most common CFA presentation)
               cluster = "twpair") 
#ask about this 
varTable(Freq_fit)

# Plot model
semPaths(Freq_fit, # CFA model
         title = F, 
         what = "std", # print standardized factor loadings
         intercepts = F, 
         residuals = F, 
         layout = "tree2", # layout of figures
         edge.label.cex = .8)

# Note: CFI is the Comparative Fit Index – values can range between 0 and 1 (values greater than 0.90, conservatively 0.95 indicate good fit)
#CFA Summary 
## it changed to be .774 instead of .773 when I took out typical drinks  
### Provides ALOT of information
summary(Freq_fit, 
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
fitmeasures(Freq_fit,
            fit.measures = fit.stats)



mod_ind <- modificationindices(Freq_fit)
head(mod_ind[order(mod_ind$mi, decreasing = T),], 20) # computes MI and ranks sources of misfit
# results show residual relationship between Sed_Sx and Op_Sx is largest source of misfit
## model already fits well so no additional changes are needed based on MI


#
Fscores  <- lavPredict(Freq_fit , 
                       type = "lv", # standardized fscores
                       method = "EBM") %>%  # how to calculate scores, look at lavaan manual for what method is best for your model
  as.data.frame()

df1 <- cbind(df, Fscores)

#------------------------------------------------------------
#  Pulling out paramaters you want (many time to make tables)
#------------------------------------------------------------
# lavInspect "pulls" out the elements you specify

# this pulls out standardized parameters
lavInspect(Freq_fit,
           what = "std")

# this pulls out standardized factor loadings specifically
lavInspect(Freq_fit,
           what = "std")$lambda

write.csv(df1,"Updated_alc_variables.csv", row.names = FALSE)



