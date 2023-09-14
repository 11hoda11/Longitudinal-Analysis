
#----------------------------------------------------------------------------------

# load libraries
library(lme4)
library(nlme)
library(lattice)
library(ggplot2)
library(lmerTest)
library(janitor)
library(readxl)
library(openxlsx)
library(dplyr)
library(optimx)
library(sjPlot)
library(sjlabelled)
library(memisc)
library(plotly)
library(rgl)
library(akima)
library(sjPlot)
library(meta)
library(metafor)
library(metasens)
library(SCMA)
# set the current directory and reading data
setwd("C:/Users/hodan/OneDrive/Desktop/Downloads TRI/Ambient hosp/longitudinal")
longitudinaldata = read_excel(file.choose(), col_types = 'guess')

  #"Longitudinal Analysis-Results-Hoda - after.txt", header = TRUE) 

longitudinaldata$MOS.minimum_cm = longitudinaldata$MOS.minimum*100
longitudinaldata$MOS.average_cm = longitudinaldata$MOS.average*100
longitudinaldata$Walking.speedcm = longitudinaldata$Walking.speed*100
longitudinaldata$Step.lengthcm = longitudinaldata$Step.length*100
longitudinaldata$Step.widthcm = longitudinaldata$Step.width*100
longitudinaldata$CV.step.timePercent = longitudinaldata$CV.step.time*100
longitudinaldata$CV.step.lengthPercent = longitudinaldata$CV.step.length*100
longitudinaldata$CV.step.widthPercent = longitudinaldata$CV.step.width*100
longitudinaldata$SD.sacr.MLcm = longitudinaldata$SD.sacr.ML*100
longitudinaldata$RMS.sacr.ML.velocitycm = longitudinaldata$RMS.sacr.ML.velocity*100
longitudinaldata$ROM.sacr.MLcm = longitudinaldata$ROM.sacr.ML*100
longitudinaldata$timeHours = longitudinaldata$Time/3600
longitudinaldata$timeMinutes = longitudinaldata$Time/60
longitudinaldata$timeDays = longitudinaldata$Time/86400
longitudinaldata$timeWeeks = longitudinaldata$Time/(7*86400)
longitudinaldata$TIME = longitudinaldata$timeWeeks
longitudinaldata$NPI = longitudinaldata$NPIADM

longitudinaldata$MOS = longitudinaldata$MOS.average_cm
#longitudinaldata$time = convertToDateTime(longitudinaldata$time)
#longitudinaldata$MOSscaled = scale(longitudinaldata$MOS, center = TRUE, scale = TRUE)

longitudinaldata[longitudinaldata==NaN] <- NA

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

# finding coef and CI for individuals

model2_uncondGrowth = lmer(Walking.speedcm ~ 1 + TIME + (1 + TIME |ID), data = longitudinaldata, REML = FALSE)
# predicting and visualizing model 2- uncond growth
longitudinaldata_predictions <- longitudinaldata %>%
  mutate(model2_predict = predict(model2_uncondGrowth))
#group_by(TIME,SEX) %>%
#summarize(mean_SEX_pred = mean(model2_predict))

longitudinaldata_predictions$sd = sd(longitudinaldata_predictions$model2_predict)

summary(model2_uncondGrowth)


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



#Slopesd <-  setNames(res2["slope_se"]*sqrt(N) ,c("SD"))
#var <-  setNames(res2["slopesd"]^2,c("VAR"))

result <- cbind(res2["slope"],res2["slope_se"] , lowerCI,upperCI)

# vc <- VarCorr(model2_uncondGrowth)
# varcomps <- c(unlist(lapply(vc,diag)), attr(vc, "sc")^2)

###

#Meta analysis
resultdata = read_excel(file.choose(), col_types = 'guess')

#met <- c(escalc(measure="MD", m1i=resultdata$Estimatepre, m2i=resultdata$zero, sd1i=resultdata$sdpre,
                # sd2i=resultdata$zero, n1i=resultdata$Weightpre, n2i=resultdata$Weightpre,
                #slab=paste(resultdata$Subjects), digits=3),
                #ci.lb=resultdata[4],ci.ub=resultdata[5])
metrmanon <- rma(yi=resultdata$Slopenon, vi=resultdata$Varnon, sei=resultdata$sepnon,
                 weights=resultdata$Weightnon,
                 measure="GEN", intercept=TRUE, slab=paste(resultdata$Subjectsnon),
                 add=1/2, to="only0", drop00=FALSE, vtype="LS",
                 method="REML", weighted=TRUE, test="z",
                 level=95, digits=2,  verbose=FALSE)


metrmapre <- rma(yi=resultdata$Slopepre, vi=resultdata$Varpre, sei=resultdata$sepre,
    weights=resultdata$Weightpre,
    measure="GEN", intercept=TRUE, slab=paste(resultdata$Subjectspre),
    add=1/2, to="only0", drop00=FALSE, vtype="LS",
    method="REML", weighted=TRUE, test="z",
    level=95, digits=2,  verbose=FALSE)

metrmapost <- rma(yi=resultdata$Slopepost, vi=resultdata$Varpost, sei=resultdata$sepost,
 
                  measure="GEN", intercept=TRUE, slab=paste(resultdata$Subjectspost),
                 add=1/2, to="only0", drop00=FALSE, vtype="LS",
                 method="REML", weighted=TRUE, test="z",
                 level=95, digits=2,  verbose=FALSE)


forest(metrmanon, ci.lb=resultdata$LCInon, ci.ub=resultdata$UCInon,
       annotate=TRUE, showweights=TRUE, header="Subjects",
         top=3, steps=5,alim=c(-5,5),ylim=c(-1,45),xlim=c(-10,10),addpred=TRUE,
       level=95, refline=0, digits=2L,width=2,xlab="Slope",cex=.8,	
       efac=1, pch=15, plim=c(0.5,1.5),fonts=20)
par(cex=.75, font=.8)
text(c(6,0), 44, c("Weight","Gait Speed"))
text(c(-8.5), 42, c("No event"))

par(font = 1, cex = 1.2)
forest(metrmapre, ci.lb=resultdata$LCIpre, ci.ub=resultdata$UCIpre,
       annotate=TRUE, showweights=TRUE, header="Subjects",
       top=3, steps=5,alim=c(-5,5),ylim=c(-1,17),xlim=c(-10,10),addpred=TRUE,
       level=95, refline=0, digits=2L,width=2,xlab="Slope",cex=.8,	
       efac=1, pch=15, plim=c(0.5,1.5),fonts=20)
par(cex=.75, font=.8)
text(c(6,0), 16, c("Weight","Gait Speed"))
text(c(-8.5), 14, c("Before event"))


par(font = 1, cex = 1.2)
forest(metrmapost, ci.lb=resultdata$LCIpost, ci.ub=resultdata$UCIpost,
       annotate=TRUE, showweights=TRUE, header="Subjects",
       top=3, steps=5,alim=c(-5,5),ylim=c(-1,12),xlim=c(-10,10),addpred=TRUE,
       level=95, refline=0, digits=2L,width=2,xlab="Slope",cex=.8,	
       efac=1, pch=15, plim=c(0.5,1.5))
par(cex=.75, font=.8)
text(c(7.2,0), 11, c("Weight","Cadence"))
text(c(-9.2), 9, c("After event"))

#abc <- structure(list(Subject = c("Subject 2", "Subject 3", "Subject 4", "Subject 5", 
 #                               "Subject 6", "Subject 7", "Subject 8", "Subject 9", 
  #                              "Subject 10", "Subject 11", "Subject 13", "Subject 14"), 
   #              Slope = result[1], LCI = result[2],UCI = result[3]), 
    #             class = "data.frame", row.names = c(NA, -12L))

#abc <- structure(list(Subject = resultdata[1], 
 #                     Slope = resultdata[2], LCI = resultdata[3],UCI = resultdata[4]), 
  #               class = "data.frame", row.names = c(NA, -12L))

###

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
####


# 2- second model: unconditional growth model for post data
longitudinaldatapost$timeWeekspost = longitudinaldatapost$Time/(7*86400)
longitudinaldatapost$TIMEpost = longitudinaldatapost$timeWeekspost
model2_uncondGrowthpost = lmer(Cadence  ~ 1 + TIMEpost + (1 + TIMEpost |ID), data = longitudinaldatapost, REML = FALSE)



# predicting and visualizing model 2- uncond growth
longitudinaldatapost_predictions <- longitudinaldatapost %>%
  mutate(model2_predictpost = predict(model2_uncondGrowthpost))
#group_by(TIME,SEX) %>%
#summarize(mean_SEX_pred = mean(model2_predict))

longitudinaldatapost_predictions$sd = sd(longitudinaldatapost_predictions$model2_predictpost)
#apply(longitudinaldata_predictions, 2, sd, na.rm = TRUE)
summary(model2_uncondGrowthpost)

# finding coef and CI for individuals


ccpost <- coef(model2_uncondGrowthpost)$ID
## variances of fixed effects
fixed.varspost <- diag(vcov(model2_uncondGrowthpost))
## extract variances of conditional modes
r1post <- ranef(model2_uncondGrowthpost,condVar=TRUE)
cmode.varspost <- t(apply(cv <- attr(r1post[[1]],"postVar"),3,diag))
seValspost <- sqrt(sweep(cmode.varspost,2,fixed.varspost,"+"))
respost <- cbind(ccpost,seValspost)
res2post <- setNames(respost[,c(1,3,2,4)],
                 c("int","int_se","slope","slope_se"))

upperCIpost <-  setNames(res2post["slope"] + 1.96*res2post["slope_se"],c("UCI"))
lowerCIpost <-  setNames(res2post["slope"]  - 1.96*res2post["slope_se"],c("LCI"))

resultpost <- cbind(res2post["slope"],lowerCIpost,upperCIpost)






