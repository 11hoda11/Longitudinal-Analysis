
# Visualizing Linear Mixed-Effect Model Longitudinal Analysis (Spaghetti plots)
# Author: Hoda Nabavi
# Date: September 15, 2020

# This code plots based on in the Linear Mixed-Effect Model Longitudinal 
# Analysis script output. (customized response_variable and predictor_variable) 
#----------------------------------------------------------------------------------

# load libraries
library(lme4)
library(ggplot2)
library(readxl)
library(openxlsx)
library(dplyr)


# Set working directory to the location of your data files
setwd("path/to/your/data/folder")

# Prompt the user to select the input data file
data_file <- file.choose()
longitudinaldata_predictions <- read_excel(data_file, col_types = 'guess')

#-------------------------------------------------------------------------------------

#Spaghetti plots

#-------------------------------------------------------------------------------------
## Before-event participants (11 colors)

ggplot(longitudinaldata_predictions, aes(x = TIME, y = model2_predict)) +
  geom_line(aes(group =ID, colour = as.factor(ID) ) , alpha = 0.5, size=1) +
  #geom_smooth(size = 2, method='lm', se=TRUE, colour='red') +
  scale_colour_manual(values = c("darkred", "blue", "cyan", "blueviolet",
                                 "chartreuse", "darkblue" ,"chocolate", "deeppink",
                                 "coral", "darkolivegreen", "darkorchid"))+
  #scale_color_manual(values =rainbow(40, s=.6, v=.9)[sample(1:40,40)],name  ="")+ 
  theme_bw(base_size = 14) + # changes default theme
  xlab("Time (weeks)") + # changes x-axis label
  ylab("Step time (s) ") +     # changes y-axis label
  ylim(0.4,0.9)+          # change y-axis limit
  xlim(0,15)+            # change x-axis limit
  ggtitle("Participants before medical event")+
  guides(color = guide_legend(title = "ID"))+
  theme(axis.text.x = element_text(size=12),axis.text.y = element_text(size=12))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

ggsave("Step time-before.tiff", units="in", width=5, height=5, dpi=1000)
ggsave("Step time-before.eps", units="in", width=5, height=5, dpi=1000)


#------------------------------------------------------------------------------------
## After-event participants (6 colors)
ggplot(longitudinaldata_predictions, aes(x = TIME, y = model2_predict)) +
  geom_line(aes(group =ID, colour = as.factor(ID) ) , alpha = 0.5, size=1) +
  #geom_smooth(size = 2, method='lm', se=TRUE, colour='red') +
  scale_colour_manual(values = c("darkcyan", "blue", "blueviolet",
                                 "darkblue" , "deeppink", "black"))+
  #scale_color_manual(values =rainbow(40, s=.6, v=.9)[sample(1:40,40)],name  ="")+ 
  theme_bw(base_size = 14) + # changes default theme
  xlab("Time (weeks)") + # changes x-axis label
  ylab("Gait speed (cm/s) ") +     # changes y-axis label
  ylim(15,90)+          # change y-axis limit
  xlim(0,15)+            # change x-axis limit
  ggtitle("Participants after medical event")+
  guides(color = guide_legend(title = "ID"))+
  theme(axis.text.x = element_text(size=12),axis.text.y = element_text(size=12))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
#pg <- ggplot_build(p)
#s<- pg[["data"]][[2]][["y"]]%>%
  #mutate(double(ID = pg[["data"]][[2]][["group"]]))

#ggsave("Cadence-after.jpg", units="in", width=5, height=5, dpi=1000)
ggsave("Gait speed-after.tiff", units="in", width=5, height=5, dpi=1000)
ggsave("Gait speed-after.eps", units="in", width=5, height=5, dpi=1000)

#-----------------------------------------------------------------------------------

## Non-event participants (black)
ggplot(longitudinaldata_predictions, aes(x = TIME, y = model2_predict)) +
  geom_line(aes(group =ID) , alpha = 0.5, size=1) +
  #geom_smooth(size = 2, method='lm', se=TRUE, colour='red') +
  theme_bw(base_size = 14) + # changes default theme
  xlab("Time (weeks)") + # changes x-axis label
  ylab("eMOS (cm) ") +     # changes y-axis label
  ylim(2,13)+          # change y-axis limit
  xlim(0,15)+            # change x-axis limit
  ggtitle("Participants without medical event")+
  theme(axis.text.x = element_text(size=12),axis.text.y = element_text(size=12))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

ggsave("eMOS-without.tiff", units="in", width=5, height=5, dpi=1000)
ggsave("eMOS-without.eps", units="in", width=5, height=5, dpi=1000)

