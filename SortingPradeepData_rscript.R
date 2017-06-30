# ---
#   title: "CodeForMachineLearningFormat"
# author: "Kirk Geier"
# date: "June 28, 2017"
# output: html_document
# ---
  
  #Load Packages

library("broom", lib.loc="~/R/R-3.3.1/library")
library("tidyr", lib.loc="~/R/R-3.3.1/library")
library("ggplot2", lib.loc="~/R/R-3.3.1/library")
library("gridExtra", lib.loc="~/R/R-3.3.1/library")
library("dplyr", lib.loc="~/R/R-3.3.1/library")
library("tidyr", lib.loc="~/R/R-3.3.2/library")
library("plotly", lib.loc="~/R/R-3.3.2/library")
library(plyr)
library(data.table)
library(reshape2)
library(readr)

#Loading Sample data####
#note, 9a and 9b were combined in advance to this. 9a block 11 crashed part way through. 
mylistnew <- list(seq(1:37))
i=1
for (i in 1:37){
  data_dir = 'C:/Users/kgeier/Google Drive/OlsenLab_cloud/All Experiments/EyeTracking/ObjFamETStudy/MACHINE_LEARNING_codeForPradeep/SampleReportsAll' 
  filename =  i
  fileextension = ".csv"
  filename = paste0(filename, fileextension)
  filepath = paste(data_dir, '/', filename, sep = ''); filepath
  
  mylistnew[[i]] <- fread(filepath)
  
}

# Looking at sample data to see if it's what we expect (uhoh, some are missing 6 columns (bc i didn't report them from DV))
mylistnew[[5]] -> visualizer19
mylistnew[[1]] -> visualizer13

#Load data 2####
#Loading in data from other script (Objfam_qualitychecks_accuracy_betweenSubj_april11) If it's still named that. 
df.merged_wdp <- fread('C:/Users/kgeier/Google Drive/OlsenLab_cloud/All Experiments/EyeTracking/ObjFamETStudy/MACHINE_LEARNING_codeForPradeep/dp_and_subqAcc.csv')


#merging sample data with dprime and hit/miss

#practice not in a loop
visualizer19 <- cbind(visualizer19, seq(1:length(visualizer19$RECORDING_SESSION_LABEL)))
test <- merge(visualizer19, df.merged_wdp, by = c('RECORDING_SESSION_LABEL', 'TRIAL_LABEL'), all = F)
huh <- test[is.na(test$V2),]
wut <- test[duplicated(test$V2),]
#ok. So no duplicates, and no nas. BUT, 782 rows in the new one that aren't in the old one...
#AGHHHHH wth how does that happen


mylist2 <- list(seq(1:37))
j =1 
for (j in 1:37) {
  mylist2[[j]] <- merge(mylistnew[[j]], df.merged_wdp, by = c('RECORDING_SESSION_LABEL', 'TRIAL_LABEL'), all = F)
  
} 

mylist2[[32]] -> visualizerMerged

#GOALS of this R code####
#1. Label each row as yes or no for whether the subject is being excluded 
 #a) import a new df with whether they will be excluded based on d'
 #b) merge
 #c) label
#2. Label each row as hit/miss/FA/CR
 #a) import csv with each subject block trial and subsequent accuracy
 #b) merge
#2.5. set it to show only the used eye's location
#3. Save each trial as it's own csv file based on value of subid, block/trialid/imagename/hitormiss
 #a) loop through each subject and subset by all the variables until they are all in tiny df
 #b) make folders somehow as you write out the different files. 












