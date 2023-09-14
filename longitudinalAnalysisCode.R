

# Linear Mixed-Effect Model Longitudinal Analysis script
# Author: Hoda Nabavi
# Date: September 15, 2020

# Make sure to load your data file and set the working directory correctly.
# User can customize the response_variable and predictor_variable.

#----------------------------------------------------------------------------------

# Load necessary libraries
library(lme4)
library(nlme)
library(lattice)
library(ggplot2)
library(lmerTest)
library(readxl)
library(openxlsx)
library(dplyr)
library(optimx)
library(sjPlot)
library(sjPlot)

# Set working directory to the location of your data files
setwd("path/to/your/data/folder")

# Prompt the user to select the input data file
data_file <- file.choose()
longitudinaldata <- read_excel(data_file, col_types = 'guess')

# Preprocess data (e.g., convert units, handle missing values)
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

longitudinaldata[longitudinaldata==NaN] <- NA

# Separate data for different groups (non-hospitalized, hospitalized)
nonhosp = subset(longitudinaldata, Hosp. == 0, select = Hosp:timeWeeks) # non-hospitalized
hosp = subset(longitudinaldata, Hosp. == 1, select = Hosp:timeWeeks) # hospitalized

# ----------------------------------------------------------------------------------

# Modeling Section

# Define the response variable and predictor(s) you want to use
response_variable <- "MOS.minimum_cm"  # Change this to your response variable
predictor_variable <- "AGE"  # Change this to your predictor variable

#-----------------------------------------------------------------------------------


# Model 1: Unconditional Means Model
model1_uncondMeans <- lmer(as.formula(paste(response_variable, "~ 1 + (1 | ID)")), data = longitudinaldata, REML = FALSE)
longitudinaldata_predictions <- longitudinaldata %>%
  mutate(model1_predict = predict(model1_uncondMeans))
summary(model1_uncondMeans)

sum1<-summary(model1_uncondMeans)
model1_coef<-sum1[["coefficients"]]
model1_coef

# Save the coefficients (if needed)
# write.xlsx(model1_coef, file = "model_coef_Variable_name.xlsx",row.names = TRUE)

#------------------------------------------
# Model 2: Unconditional Growth Model
model2_uncondGrowth <- lmer(as.formula(paste(response_variable, "~ 1 + TIME + (1 + TIME | ID)")), data = longitudinaldata, REML = FALSE)

longitudinaldata_predictions <- longitudinaldata_predictions %>%
  mutate(model2_predict = predict(model2_uncondGrowth))
summary(model2_uncondGrowth)

sum2<-summary(model2_uncondGrowth)
model2_coef<-sum2[["coefficients"]]
model2_coef

# Save the coefficients (if needed)
# write.xlsx(model2_coef, file = "model_coef_Variable_name.xlsx",row.names = TRUE)

plot_model(model2_uncondGrowth, type ="est", colors = c("black"),line.size = 1)+
  ylab("eMOS (cm)") +
  xlab("Time (weeks)") +
  theme_bw(base_size = 16) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())


#------------------------------------------
# Model 3: Adding one predictor
model3 <- lmer(as.formula(paste(response_variable, "~ 1 + TIME *", predictor_variable, "+ (1 + TIME | ID)")), data = longitudinaldata, REML = FALSE, na.action = na.omit)

longitudinaldata_predictions <- longitudinaldata_predictions %>%
  mutate(model3_predict = predict(model3, re.form = NA))
summary(model3)

sum3<-summary(model3)
model3_coef<-sum3[["coefficients"]]
model3_coef

# Save the coefficients (if needed)
# write.xlsx(model3_coef, file = "model_coef_Variable_name.xlsx",row.names = TRUE)

# Plot the model3

tiff("Figure2D.tiff", units="in", width=5, height=5, res=300)

plot_model(model3,  type = "int", colors = c("black", "grey"),line.size = 1, mdrt.values = "minmax")+
  ylab("Step width CV (%)") +
  xlab("Time (weeks)") +
  theme_bw(base_size = 16) +
  scale_colour_manual(labels = c("Low NPI","High NPI"),values=c("black","grey"))+
  scale_fill_grey()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),legend.position = c(.25,.8),legend.title = element_blank(),legend.text = element_text(size=12),legend.key.size = unit(.6, "cm"))

dev.off()


#----------------------------------------------------------------------------------------

# Fit linear regression models on model2_prediction for each group of data points

models <- longitudinaldata_predictions %>%
  group_by(ID) %>%
  do(model = lm(model2_predict ~ TIME, data = .))

# Extract slope coefficients from each model
#slopes <- models[[[2]][[1]][["coefficients"]][["TIME"]]

slopes <- (Slopes = models %>% 
             pull(model) %>% 
             map_dbl(~ coef(.x)["TIME"]) %>%
             as.data.frame())%>%
  mutate(ID = unique(models$ID))%>%
  rename(slope = 1)%>%
  select(ID, everything())


# Fit linear regression model for all data points

#model_all <- lm(model2_predict ~ TIME, data = longitudinaldata_predictions)
# Extract slope coefficients
#slopes_all <- coef(model_all)[2]
#slope_result <- rbind(slopes, slopes_all)

# Save the slopes
write.xlsx(slopes, file = "slope result_Gait_ variable.xlsx") 
#-----------------------------------------------------------------------

# Save the result 
write.xlsx(longitudinaldata_predictions, file = "longitudinaldata_predictions.xlsx",row.names = TRUE)

