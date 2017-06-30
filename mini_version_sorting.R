# ---
# title: "CodeForMachineLearningFormat"
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
mylistnew <- list(seq(4:6))
i=4
for (i in 4:6){
  data_dir = 'C:/Users/kgeier/Google Drive/OlsenLab_cloud/All Experiments/EyeTracking/ObjFamETStudy/MACHINE_LEARNING_codeForPradeep/mini_sampleReports' 
  filename =  i
  fileextension = ".csv"
  filename = paste0(filename, fileextension)
  filepath = paste(data_dir, '/', filename, sep = ''); filepath
  
  mylistnew[[i]] <- fread(filepath)
  
}

# Looking at sample data to see if it's what we expect (uhoh, some are missing 6 columns (bc i didn't report them from DV))
mylistnew[[5]] -> visualizera


#Load data 2####
#Loading in data from other script (Objfam_qualitychecks_accuracy_betweenSubj_april11) If it's still named that. 
df.merged_wdp <- fread('C:/Users/kgeier/Google Drive/OlsenLab_cloud/All Experiments/EyeTracking/ObjFamETStudy/MACHINE_LEARNING_codeForPradeep/dp_and_subqAcc.csv')


#2. Label each row as hit/miss/FA/CR and dprime
#practice not in a loop
#making a vector of relevant columns I want from df.merged_wdp
RelCol <- c("SID", "RECORDING_SESSION_LABEL", "X__Reaction_Time__1", "block", "image_filename", "oldnearorfar", "test_confidence.x", "TRIAL_LABEL", "SubsequentAccuracy", "SubsequentMorph", "test_confidence.y", "dprime_nearonly_noguess", "dprime_faronly_noguess")

visualizera <- cbind(visualizera, seq(1:length(visualizera$RECORDING_SESSION_LABEL)))
test <- merge(visualizera, df.merged_wdp[ , RelCol, with = F], by = c('RECORDING_SESSION_LABEL', 'TRIAL_LABEL'), all = F)
huh <- test[is.na(test$V2),]
wut <- test[duplicated(test$V2),]
#ok. So no duplicates, and no nas. But 1 row missing in new one. Presumably an na that didn't match?

#Loop to merge d' and hit/miss (and many other rows)
mylist2 <- list(seq(4:6))
j =4 
for (j in 4:6) {
  mylist2[[j]] <- merge(mylistnew[[j]], df.merged_wdp[ , RelCol, with = F], by = c('RECORDING_SESSION_LABEL', 'TRIAL_LABEL'), all = F)
} 



#2.5. set it to show only the used eye's location

#in loop for all subj
mylist3 <- list(seq(4:6))
k = 4
for (k in 4:6) {
  #Setting list number to df named visualizermerged
  mylist2[[k]] ->  visualizerMerged
  #Doing ifelse statement to combine left and right based on "eye used' column
  visualizerMerged$eye_gaze_X <- ifelse(visualizerMerged$EYE_TRACKED == 'Right', visualizerMerged$RIGHT_GAZE_X, visualizerMerged$LEFT_GAZE_X)
  visualizerMerged$eye_gaze_Y <- ifelse(visualizerMerged$EYE_TRACKED == 'Right', visualizerMerged$RIGHT_GAZE_Y, visualizerMerged$LEFT_GAZE_Y)
  visualizerMerged$eye_in_blink <- ifelse(visualizerMerged$EYE_TRACKED == 'Right', visualizerMerged$RIGHT_IN_BLINK, visualizerMerged$LEFT_IN_BLINK)
  #And Changing Trial: # to #. 
  visualizerMerged$TRIAL_LABEL <- gsub("Trial: ", "", visualizerMerged$TRIAL_LABEL)
  visualizerMerged -> mylist3[[k]] 
}

#3. Loop to save with everything in its own folder by trial...

#non-looped test

m =1 
n =1
#saving individual trial to it's own folder.
for (m in 4:6){
mylist3[[m]] -> alltrials
  for (n in 1:length(alltrials$TRIAL_LABEL)) {
trial1 <- subset(alltrials, subset = alltrials$TRIAL_LABEL == n)
s1 <- trial1[1, 'SID']
b1 <- trial1[1,"block.x"]
t1 <- trial1[1,"TRIAL_LABEL"]
i1 <- trial1[1,"image_filename.x"]
sa1 <- trial1[1,"SubsequentAccuracy"]

mainDir <- ('C:/Users/kgeier/Google Drive/OlsenLab_cloud/All Experiments/EyeTracking/ObjFamETStudy/MACHINE_LEARNING_codeForPradeep/OutputFolder')
subDira <- paste0("Subject_", s1)
subDirb <- paste0("block_", b1)
subDirc <- paste0("trial_", t1)
subDird <- paste0("image_", i1)
subDire <- paste0("SubqAcc_", sa1)

#Slowly building directory structure 
path <- file.path(mainDir, subDira)
dir.create(path, showWarnings = F)
path <- file.path(path, subDirb)
dir.create(path, showWarnings = F)
path <- file.path(path, subDirc)
dir.create(path, showWarnings = F)
path <- file.path(path, subDird)
dir.create(path, showWarnings = F)
path <- file.path(path, subDire)
dir.create(path, showWarnings = F)

pathfinal <- file.path(mainDir,subDira,subDirb,subDirc,subDird,subDire)
write.csv(x=trial1, file= paste0(pathfinal,"/","samplereport.csv"), row.names = FALSE)

}
}

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
#4. Decide if the subq accuracy column used should be from the version that counts guesses as new resp or guess. 











