# Getting-and-Cleaning-Data-Course-Project
Getting and Cleaning Data Course Project - Final Assignment

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

The dataset includes the following files:
=========================================

- 'README.txt' (this file)
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following steps were requested in the assignment:
=================================================================
1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement.
3. Use descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script run_analysis.R was created in a way that the following operations were executed to comply with what was requested above:
1. set the working environment
```
    setwd("~pfilgueira/Dropbox/Pessoal/Especializacao/Data Science/Module 3")
    library(data.table)
```
2. load the two dataset files with the main data
```
    data_test <- read.table("./UCI HAR Dataset/test/X_test.txt")   # test set
    data_train <- read.table("./UCI HAR Dataset/train/X_train.txt") # training set
```

3. load the two dataset files with activity data
```
    activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt")   # test labels
    activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt") # training labels
```
4. load the two dataset files with subject data
```
    subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") # subject who performed
    subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") # subject who performed
```
5. merged, based on the rows, each of the categories above
```
    merged_data <- rbind(data_train, data_test)
    merged_activity <- rbind(activity_train, activity_test)
    merged_subject <- rbind(subject_train, subject_test)
```    
6. load the activity labels to facilitate the column names for the main data sets
```
    activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]  # interested in the V2 column
```
7. eliminated all variables not related to mean and std deviation by using features_mean_sdv <- grep("mean()|std()", features)
```
    features <- read.table("./UCI HAR Dataset/features.txt")[,2]
    features_mean_sdv <- grep("mean()|std()", features)
```
8. merged based on columns the 3 files already merged by rows before.   Each category crated one file that were merged together in just one.
```
    names(merged_data) <- features
    merged_data <- merged_data[, features_mean_sdv] # only mean and std variation
    names(merged_activity) <- c("activity")
    names(merged_subject) <- c("subject")
    
    data_part1 <- cbind(merged_subject, merged_activity)
    data_final <- cbind(merged_data, data_part1)
```    
9. finally, renamed the abreviated fields like "f", "t", "Acc", "etc" to their respective full names.  Details below:
```
    #^t --> time
    # ^f --> frequency
    # Acc --> Accelerometer
    # Gyro --> Gyroscope
    # Mag --> Magnitude
    # BodyBody --> Body

    names(data_final)<-gsub("^t", "time", names(data_final))
    names(data_final)<-gsub("^f", "frequency", names(data_final))
    names(data_final)<-gsub("Acc", "Accelerometer", names(data_final))
    names(data_final)<-gsub("Gyro", "Gyroscope", names(data_final))
    names(data_final)<-gsub("Mag", "Magnitude", names(data_final))
    names(data_final)<-gsub("BodyBody", "Body", names(data_final))
```
10. then, to complete the assignment, a tidy data file was created by aggregating the mean based on subject, activity and main data.
```
    data_tidy <- aggregate(. ~subject + activity, data_final, mean)
```    
11. ordered the file by subject and actvity and then, finally, write the final file tidydata.txt.
```
    data_tidy <- data_tidy[order(data_tidy$subject, data_tidy$activity),]
    write.table(data_tidy, file = "tidydata.txt",row.name=FALSE)
```    
That's all folks!


