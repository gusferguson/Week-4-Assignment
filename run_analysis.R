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

#unable work out how to do this
tidyData <- selectedData

#output tidy dataset
write.csv(tidyData, file = "tidy_data.csv")
