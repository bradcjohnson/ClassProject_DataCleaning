## Data manipulation script for extracting and summarizing 
## observations of mean and std. deviation 

# Read in text files using default delimiter of space
features  <- read.table("./UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)
activtxt  <- read.table("./UCI HAR Dataset/activity_labels.txt")
tstsubj   <- read.table("./UCI HAR Dataset/test/subject_test.txt")
tstactiv  <- read.table("./UCI HAR Dataset/test/y_test.txt")
tstobserv <- read.table("./UCI HAR Dataset/test/x_test.txt")
trnsubj   <- read.table("./UCI HAR Dataset/train/subject_train.txt")
trnactiv  <- read.table("./UCI HAR Dataset/train/y_train.txt")
trnobserv <- read.table("./UCI HAR Dataset/train/x_train.txt")

# load package libraries
library(dplyr)
library(reshape2)

# initial assignment of meaningful variable names
features  <- select(features, fldNum = V1, varDescribe = V2)
tstsubj   <- select(tstsubj, Subj = V1)
tstactiv  <- select(tstactiv, activ = V1)
trnsubj   <- select(trnsubj, Subj = V1)
trnactiv  <- select(trnactiv, activ = V1)

# combine id columns with observations
tstsubjactiv <- cbind(tstsubj, tstactiv)
tstobservcmb <- cbind(tstsubjactiv,tstobserv)
trnsubjactiv <- cbind(trnsubj, trnactiv)
trnobservcmb <- cbind(trnsubjactiv,trnobserv)
# combine test and training data
observations <- rbind(tstobservcmb,trnobservcmb)

# add ID column to use in merges
observations <- cbind(observations,ID = as.integer(rownames(observations)))

# create table with identifiers only for extract of means and std. deviations
observextr <- select(observations,Subj,activ,ID)
# create column with meaningful activity labels
observextr <- merge(observextr,activtxt,by.x="activ",by.y="V1")
names(observextr)[names(observextr) == "V2"] <- "ActivType"

# extract means and std. deviation columns using features list
rowct <- nrow(features)
for (i in 1:rowct) {
    featureName <- features[i,2]
    # check if feature is of type mean or std. deviation
    if (length(grep("mean()",featureName)) > 0 || length(grep("std()",featureName)) > 0) {
        varCol <- paste("V",i,sep="")
        # revise string to create legal column name, no parentheses
        colName <- gsub("-","_",featureName)
        colName <- gsub("\\()","",colName)
        # extract observation column
        observTemp <- select(observations, ID, one_of(varCol))
        # assign meaningful column name
        names(observTemp)[names(observTemp) == varCol] <- colName
        # add column to extract
        observextr <- merge(observextr,observTemp,by.x="ID",by.y="ID")
    }
} 

# reconfigure extract with all observation-types in one column for calculation of means
observMelt <- melt(observextr[,2:83], id.vars = c("Subj", "activ", "ActivType"))
# calculate means
observMean <- aggregate(value~Subj+activ+ActivType+variable, observMelt, mean )
# reestablish columns for observation-types
observMeanDisp <- dcast(observMean, Subj+activ+ActivType ~ variable)
# write table to text file
write.table(observMeanDisp,"observMean.txt",row.name=FALSE)

# clean up working tables, variables
rm(features,      tstsubj,      tstactiv,     trnsubj,      trnactiv,
   tstsubjactiv, tstobservcmb, trnsubjactiv, trnobservcmb, observations,
   observextr,    observTemp,   observMelt,   observMean,   observMeanDisp)
rm(rowct, featureName, varCol, colName)