#############################
# R script called run_analysis.R that does the following.
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.
############################

#load required libraries
library(dplyr)
library(doBy)

#check data directory exists/create it
if(!file.exists("./data")){dir.create("./data")}

#set URL and download file from URL
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./data/Dataset.zip", method="curl")

#unzip data file
unzip(zipfile="./data/Dataset.zip", exdir="./data")

#set working directory to data download directory
setwd("./data")

#read in label and data files
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")

#assign appropriate column names
colnames(activityLabels) <- c('activityId', 'activityType')
colnames(subjectTest) <- "subjectId"
colnames(xTest) <- features[ , 2]
colnames(yTest) <- "activityId"
colnames(subjectTrain) <- "subjectId"
colnames(xTrain) <- features[ , 2]
colnames(yTrain) <- "activityId"

#combine test datasets
testData <- cbind(subjectTest, yTest, xTest)

#combine training datasets
trainingData <- cbind(subjectTrain, yTrain, xTrain)

#combine test and training datasets
combinedDataset <- rbind(testData, trainingData)

#create vector of column names
columnNames <- colnames(combinedDataset)

#identify columns to retain - activityID, subjectID
#and any with mean or std in them
retainColumns <- (grepl("activityId" , columnNames) | 
                    grepl("subjectId" , columnNames) | 
                    grepl("mean.." , columnNames) | 
                    grepl("std.." , columnNames)
                  )

#use retainColumns to select columns required
selectedData <- combinedDataset[ , retainColumns == TRUE]

#convert activityId column into factors
selectedData$activityId <- factor(selectedData$activityId)

#substitute activity name into activityID
levels(selectedData$activityId) <- c("LAYING",
                                      "SITTING",
                                      "STANDING",
                                      "WALKING",
                                      "WALKING_DOWNSTAIRS",
                                      "WALKING_UPSTAIRS")

#make column names more readable
names(selectedData) <- gsub("\\()", "stdDev", names(selectedData))
names(selectedData) <- gsub("std", "stdDev", names(selectedData))
names(selectedData) <- gsub("mean", "mean", names(selectedData))
names(selectedData) <- gsub("^t", "time", names(selectedData))
names(selectedData) <- gsub("^f", "frequency", names(selectedData))
names(selectedData) <- gsub("Acc", "Accelerometer", names(selectedData))
names(selectedData) <- gsub("Gyro", "Gyroscope", names(selectedData))
names(selectedData) <- gsub("Mag", "Magnitude", names(selectedData))
names(selectedData) <- gsub("BodyBody", "Body", names(selectedData))

#create a second, independent tidy data set with the average
#of each variable for each activity and each subject.

#use summaryBy to produce tidy data table
tidyData <- summaryBy(selectedData[,3] + selectedData[,4] + selectedData[,5] +
            selectedData[,6] + selectedData[,7] + selectedData[,8] +
            selectedData[,9] + selectedData[,10] + selectedData[,11] +
            selectedData[,12] + selectedData[,13] + selectedData[,14] +
            selectedData[,15] + selectedData[,16] + selectedData[,17] +
            selectedData[,18] + selectedData[,19] + selectedData[,20] +
            selectedData[,21] + selectedData[,22] + selectedData[,23] +
            selectedData[,24] + selectedData[,25] + selectedData[,26] +
            selectedData[,27] + selectedData[,28] + selectedData[,29] +
            selectedData[,30] + selectedData[,31] + selectedData[,32] +
            selectedData[,33] + selectedData[,34] + selectedData[,35] +
            selectedData[,36] + selectedData[,37] + selectedData[,38] +
            selectedData[,39] + selectedData[,40] + selectedData[,41] +
            selectedData[,42] + selectedData[,43] + selectedData[,44] +
            selectedData[,45] + selectedData[,46] + selectedData[,47] +
            selectedData[,48] + selectedData[,49] + selectedData[,50] +
            selectedData[,51] + selectedData[,52] + selectedData[,53] +
            selectedData[,54] + selectedData[,55] + selectedData[,56] +
            selectedData[,57] + selectedData[,58] + selectedData[,59] +
            selectedData[,60] + selectedData[,61] + selectedData[,62] +
            selectedData[,63] + selectedData[,64] + selectedData[,65] +
            selectedData[,66] + selectedData[,67] + selectedData[,68] +
            selectedData[,69] + selectedData[,70] + selectedData[,71] +
            selectedData[,72] + selectedData[,73] + selectedData[,74] +
            selectedData[,75] + selectedData[,76] + selectedData[,77] +
            selectedData[,78] + selectedData[,79] + selectedData[,80] +
            selectedData[,81] ~ subjectId + activityId, data = selectedData, FUN = mean)

#restore column names
names(tidyData) <- colnames(selectedData)

#output tidy dataset
write.table(tidyData, "tidy_data.txt", row.names = FALSE, quote = FALSE)
