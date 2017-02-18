#CodeBook

##Peer-graded Assignment: Getting and Cleaning Data Course Project

##Instructions

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

##Review criteria
1. The submitted data set is tidy.
2. The Github repo contains the required scripts.
3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
4. The README that explains the analysis files is clear and understandable.
5. The work submitted for this project is the work of the student who submitted it.

##Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]

Here are the data for the project:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Check the README.txt file included with the data for further details about this dataset.

###Attribute Information:

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

###Notes: 
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

##System Specifications

Run on R Studio Version 1.0.136.

##Prerequisites

The dply library is required.

```
install.packages("dplyr")
library(dplyr)
```

##Solution

R script called run_analysis.R that does the following.

###Preparatory Code

Check that the data directory exists - if not create it.

```
if(!file.exists("./data")){dir.create("./data")}
```

Set URL and download file from URL.

```
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./data/Dataset.zip", method="curl")
```

Unzip data file

```
unzip(zipfile="./data/Dataset.zip",exdir="./data")
```

The data structure on the local hard drive is:

```
data:
	UCI HAR Dataset:
		activity_labels.txt
		features_info.txt
		features.txt
		README.txt
		test:
			Inertial Signals:
				body_acc_x_test.txt
				body_acc_y_test.txt
				body_acc_z_test.txt
				body_gyro_x_test.txt
				body_gyro_y_test.txt
				body_gyro_z_test.txt
				total_acc_x_test.txt
				total_acc_y_test.txt
				total_acc_z_test.txt
			subject_test.txt
			X_test.txt
			y_test.txt
		train:
			Inertial Signals:
				body_acc_x_train.txt
				body_acc_y_train.txt
				body_acc_z_train.txt
				body_gyro_x_train.txt
				body_gyro_y_train.txt
				body_gyro_z_train.txt
				total_acc_x_train.txt
				total_acc_y_train.txt
				total_acc_z_train.txt
			subject_train.txt
			X_train.txt
			y_train.txt
```

Set working directory to data download directory.

```
setwd("./data")
```

Read in label and data files.

```
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
```

Assign appropriate column names.

```
colnames(activityLabels) <- c('activityId', 'activityType')
colnames(subjectTest) <- "subjectId"
colnames(xTest) <- features[ , 2]
colnames(yTest) <- "activityId"
colnames(subjectTrain) <- "subjectId"
colnames(xTrain) <- features[ , 2]
colnames(yTrain) <- "activityId"
```

### 1. Merges the training and the test sets to create one data set.

Combine test datasets.

```
testData <- cbind(subjectTest, yTest, xTest)
```

Combine training datasets.

```
trainingData <- cbind(subjectTrain, yTrain, xTrain)
```

Combine test and training datasets.

```
combinedDataset <- rbind(testData, trainingData)
```

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

Create vector of column names.

```
columnNames <- colnames(combinedDataset)
```

Identify columns to retain - activityID, subjectID and any with mean or std in them. Uses retainColumns to select columns required.
```
retainColumns <- (grepl("activityId" , colNames) | 
                    grepl("subjectId" , colNames) | 
                    grepl("mean.." , colNames) | 
                    grepl("std.." , colNames)
                  )
```


```
selectedData <- combinedDataset[ , retainColumns == TRUE]
```

### 3. Uses descriptive activity names to name the activities in the data set.

Substitute activity name into activityID.

```
levels(selectedData$activityId) <- c("LAYING",
                                      "SITTING",
                                      "STANDING",
                                      "WALKING",
                                      "WALKING_DOWNSTAIRS",
                                      "WALKING_UPSTAIRS")
```

### 4. Appropriately labels the data set with descriptive variable names.

Make column names more readable.

```
names(selectedData) <- gsub("\\()", "stdDev", names(selectedData))
names(selectedData) <- gsub("std", "stdDev", names(selectedData))
names(selectedData) <- gsub("mean", "mean", names(selectedData))
names(selectedData) <- gsub("^t", "time", names(selectedData))
names(selectedData) <- gsub("^f", "frequency", names(selectedData))
names(selectedData) <- gsub("Acc", "Accelerometer", names(selectedData))
names(selectedData) <- gsub("Gyro", "Gyroscope", names(selectedData))
names(selectedData) <- gsub("Mag", "Magnitude", names(selectedData))
names(selectedData) <- gsub("BodyBody", "Body", names(selectedData))
```

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Unable work out how to do this.

Output tidy dataset as a .txt file created with write.table() using row.name=FALSE

```
write.table(tidyData, "tidy_data.txt", row.names = FALSE, quote = FALSE)
```
