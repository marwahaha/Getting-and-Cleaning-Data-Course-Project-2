# The purpose of this project is to demonstrate your ability to collect, 
# work with, and clean a data set.
# run_analysis.R

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Set the environment and load the necessary libraries
setwd("~pfilgueira/Dropbox/Pessoal/Especializacao/Data Science/Module 3")
library(data.table)

# Load the dataset files - each file has 561 columns:  dim(data_test), dim(data_train)
data_test <- read.table("./UCI HAR Dataset/test/X_test.txt")   # test set
data_train <- read.table("./UCI HAR Dataset/train/X_train.txt") # training set

# Load the activity files - each file has 1 column
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt")   # test labels
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt") # training labels

# Load the subject files - each file also with 1 column
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") # subject who performed
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") # subject who performed

# Merge all the above files in just one for each category based on their rows (rbind)
merged_data <- rbind(data_train, data_test)
merged_activity <- rbind(activity_train, activity_test)
merged_subject <- rbind(subject_train, subject_test)

# Load the activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Load the data column names and identify the ones related to mean and std dv
features <- read.table("./UCI HAR Dataset/features.txt")[,2]
features_mean_sdv <- grep("mean()|std()", features)


# Provide meaningfull fieldnames to each dataset
names(merged_data) <- features
merged_data <- merged_data[, features_mean_sdv] # only mean and std variation
names(merged_activity) <- c("activity")
names(merged_subject) <- c("subject")

# Combines everything in just one file by using column binding (cbind)
data_part1 <- cbind(merged_subject, merged_activity)
data_final <- cbind(merged_data, data_part1)

# Make better names for the existing variables by extending some acronyms/prefixes
names(data_final)<-gsub("^t", "time", names(data_final))
names(data_final)<-gsub("^f", "frequency", names(data_final))
names(data_final)<-gsub("Acc", "Accelerometer", names(data_final))
names(data_final)<-gsub("Gyro", "Gyroscope", names(data_final))
names(data_final)<-gsub("Mag", "Magnitude", names(data_final))
names(data_final)<-gsub("BodyBody", "Body", names(data_final))

# Final step - creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject
# Order by subject and activity
data_tidy <- aggregate(. ~subject + activity, data_final, mean)
data_tidy <- data_tidy[order(data_tidy$subject, data_tidy$activity),]
write.table(data_tidy, file = "tidydata.txt",row.name=FALSE)

