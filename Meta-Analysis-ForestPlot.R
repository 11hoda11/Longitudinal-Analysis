

# Visualizing Linear Mixed-Effect Model Longitudinal Analysis (Forest plots)
# Author: Hoda Nabavi
# Date: September 15, 2020

# This code plots based on in the Linear Mixed-Effect Model Longitudinal 
# Analysis script output. (customized response_variable and predictor_variable)
#----------------------------------------------------------------------------------

# load libraries
library(lme4)
library(ggplot2)
library(lmerTest)
library(dplyr)
library(meta)
library(metafor)

# Set working directory to the location of your data files
setwd("path/to/your/data/folder")

# Prompt the user to select the input data file
data_file <- file.choose()
longitudinaldata_predictions <- read_excel(data_file, col_types = 'guess')


#----------------------------------------------------------------------------------



####
# finding se and coef for model

# standard error of coefficient

#slope_se <- sqrt(diag(vcov(model2_uncondGrowth)))[2]

# estimated coefficient

#slope_coef <- fixef(model2_uncondGrowth)[2]

#upperCI <-  slope_coef + 1.96*days_se
#lowerCI <-  slope_coef  - 1.96*days_se
####

#group_by(TIME,SEX) %>%
#summarize(mean_SEX_pred = mean(model2_predict))

longitudinaldata_predictions$sd = sd(longitudinaldata_predictions$model2_predict)
cc <- coef(model2_uncondGrowth)$ID

## variances of fixed effects
fixed.vars <- diag(vcov(model2_uncondGrowth))

## extract variances of conditional modes
r1 <- ranef(model2_uncondGrowth,condVar=TRUE)
cmode.vars <- t(apply(cv <- attr(r1[[1]],"postVar"),3,diag))
seVals <- sqrt(sweep(cmode.vars,2,fixed.vars,"+"))

res <- cbind(cc,seVals)
res2 <- setNames(res[,c(1,3,2,4)],
                                 c("int","int_se","slope","slope_se"))

upperCI <-  setNames(res2["slope"] + 1.96*res2["slope_se"],c("UCI"))
lowerCI <-  setNames(res2["slope"]  - 1.96*res2["slope_se"],c("LCI"))


result <- cbind(res2["slope"],res2["slope_se"] , lowerCI,upperCI)

###

#Meta analysis

# Prompt the user to select the input data file including Meta Analysis
resultdata = read_excel(file.choose(), col_types = 'guess')

metrma <- rma(yi=resultdata$Slope, vi=resultdata$Var, sei=resultdata$se,
                 weights=resultdata$Weight,
                 measure="GEN", intercept=TRUE, slab=paste(resultdata$Subjects),
                 add=1/2, to="only0", drop00=FALSE, vtype="LS",
                 method="REML", weighted=TRUE, test="z",
                 level=95, digits=2,  verbose=FALSE)


forest(metrma, ci.lb=resultdata$LCI, ci.ub=resultdata$UCI,
       annotate=TRUE, showweights=TRUE, header="Subjects",
         top=3, steps=5,alim=c(-5,5),ylim=c(-1,45),xlim=c(-10,10),addpred=TRUE,
       level=95, refline=0, digits=2L,width=2,xlab="Slope",cex=.8,	
       efac=1, pch=15, plim=c(0.5,1.5),fonts=20)
par(cex=.75, font=.8)
text(c(6,0), 44, c("Weight","Gait Speed"))
text(c(-8.5), 42, c("No event"))


### pre-post forest plot in one graph (put 0 for subject without data)
forest(x=resultdata$Estimatepre, ci.lb=resultdata$LCIpre, ci.ub=resultdata$UCIpre,
       annotate=TRUE, showweights=FALSE, header="Forest plot",
       top=3, steps=5,alim=c(-4,4),ylim=c(0,17),xlim=c(-5,5),
       level=95, refline=0, digits=2L,width=2,xlab="Cadence Slope",	
       efac=1, pch=15, plim=c(0.5,1.5),slab=paste(resultdata$Subjectspre))
par(new=TRUE)
forest(x=resultdata$Estimatepost, ci.lb=resultdata$LCIpost, ci.ub=resultdata$UCIpost,
       annotate=TRUE, showweights=FALSE , header=FALSE,
       top=3, steps=5,alim=c(-4,4),ylim=c(0.5,17.5),xlim=c(-5,5),
       level=95, refline=0, digits=2L,width=2,xlab="",lty="dotted",
       efac=1, pch=15, plim=c(0,5,1.5),slab=paste(resultdata$Subjectspost))









