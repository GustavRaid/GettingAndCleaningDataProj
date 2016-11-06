---
title: "Read_me"
author: "Adam Reiner"
date: "November 5, 2016"
output: html_document
---
---


## Purpose

This document explains the run_analysis.R. Please see the codebook for details about the output data set deliverable.2. Step-by-step detailed documentation is included in comments in the code itself. 

## Input Data
Input data if from the Human Activity Recognition Using Smartphones Data Set.

Citation:
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 

You can view more information on the input here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

You can find the data here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## run_analysis.R code
The code assumes that the unzipped HAR Dataset is in the current working directory. 
There are several lines of code commented out that can be used to extract the data from the zip file if needed.

###Merges the training and the test sets to create one data set.
The codes starts by loading the needed text files into R. This includes the features (variable names), subject data, y and x test and training, and the activity labels.
+in this step validation is done to ensure the data loads correctly
+rbind and cbind bring the data together into one set

###Extracts only the measurements on the mean and standard deviation for each measurement.
+ Here I use ALL variables containing "mean" or "std"
+ Alterative code is commented out if you desire "mean()" or "std()"
+ Please note that directions are ambiguous on which approach is correct. There is considerable discussion in various forums

###Uses descriptive activity names to name the activities in the data set
The activity labels used are 
+WALKING
+WALKING_UPSTAIRS
+WALKING_DOWNSAIRS 
+SITTING
+STANDING
+LAYING

###Appropriately labels the data set with descriptive variable names.
+ data labels are come from the features text file
The set of variables that were estimated from these signals are

  1. mean(): Mean value
  2. std(): Standard deviation
  3. meanFreq(): Weighted average of the frequency components to obtain a mean frequency

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable

   1. gravityMean
   2. tBodyAccMean
   3. tBodyAccJerkMean
   4. tBodyGyroMean
   5. tBodyGyroJerkMean

  + These details are sourced from the features_info.text file included in the above mentioned HAR Dataset zip file.

From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

+ The data is tidy because

   1. Each Variable has its own column
   2. Each observation forms a row
   3. Each table/files stores data about one kind of observation

### Write the output and verify the data
+ output is written using output.csv()
+ data is checked to make sure values are correct and labels are correct
+ all means match with precision of +/- 10^(-19)
