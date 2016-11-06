
setwd("C:/Users/Adam/Documents/Coursera/data")

## Download and unzip the data
#dlfile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
#download.file( dlfile ,destfile="HAR.zip",method = "wininet")
#unzip("HAR.zip")

# change the WD and check the files
setwd("./UCI HAR Dataset")
list.files(recursive = TRUE)

# load the features
features <- read.table("./features.txt")
features


#Load the X test Data
test.X_test <-read.table("./test/X_test.txt")
dim(test.X_test)

# validate that all the columns are numeric
test.numeric <- lapply(test.X_test[1,], is.numeric)
length(test.numeric) ==  sum(test.numeric==TRUE)

# read the test subject data
test.subject_test <- read.table("./test/subject_test.txt")
dim(test.subject_test)

#Load the Y test data
test.Y_test <- read.table("./test/y_test.txt")
dim(test.Y_test)

# Validate the Y test data
test.numeric <- lapply(test.Y_test[1,], is.numeric)
length(test.numeric) ==  sum(test.numeric==TRUE)

# load  and check the activity lables
activity.labels <- read.table("./activity_labels.txt")
activity.labels

# Load the X training Data
train.X_train <-read.table("./train/X_train.txt")
dim(train.X_train)

# validate that all the columns are numeric
train.numeric <- lapply(train.X_train[1,], is.numeric)
length(train.numeric) ==  sum(train.numeric==TRUE)

#Load the Y training data
train.Y_train <- read.table("./train/y_train.txt")
dim(train.Y_train)

# Validate the Y training data
train.numeric <- lapply(train.Y_train[1,], is.numeric)
length(train.numeric) ==  sum(train.numeric==TRUE)

# read the train subject data
train.subject_train <- read.table("./train/subject_train.txt")
dim(train.subject_train)


## Merge the training and the test sets to create one data set.
# Add the test and training X data, y data, and subject data

x_data <- rbind(test.X_test, train.X_train)
dim(x_data)
y_data <- rbind(test.Y_test,train.Y_train)
dim(y_data)
sub_data <- rbind(test.subject_test,train.subject_train)
dim(sub_data)
# combine the y, subject, and x data to one set
y_sub_x_data <- cbind(y_data, sub_data, x_data)
dim(y_sub_x_data)

## Extracts only the measurements on the mean and standard deviation for each measurement

#create a vector locating the desired columns in the features data
# desired columns are mean and std measures. 

#*****************************************************************
# The requirement is amiguous on wheather to include variables with a format like
# the 294th 'fbodyAcc-meanFreq()-X' it is a mean after all. Ive decided to include these
# I've decside to include these variables. The alteritive code is commented out.
#*****************************************************************

features_char <- as.character(features[,2])

#right_vars_feat <- grep("mean\\(\\)|std\\(\\)", features_char)
right_vars_feat <- grep("mean|std", features_char)

# create a new vector of variables to keep, since the Y and subject data 
# are in the first two columns of the main data set
keep_vars <- c(1,2,2+right_vars_feat )

# create a subset with only the variables we want to keep
subset_data <- y_sub_x_data[,keep_vars]
dim(subset_data)

## Uses descriptive activity names to name the activities in the data set
# add descriptive activity names to the combined data set

my.data <-merge(subset_data, activity.labels, by.x = "V1", by.y = "V1")
dim(my.data)


## Appropriately labels the data set with descriptive variable names.
# add the descriptive column lables to the data
keep_names <- c("activity_number", "subjects", features_char[right_vars_feat],"activity_name")
colnames(my.data) <- keep_names

# move the activity_name variable to the second positions and gets rid of activity_number
deliverable_1 <- my.data[,c(82,2,3:81)]
dim(deliverable_1)

## From the data set in step 4, create a second, independent tidy data set with the 
## average of each variable for each activity and each subject.
# take the average of each variable for each activity and each subject
# Reshape the combined set into a tidy set
library(reshape2)
dmelt <- melt(deliverable_1, id = c("activity_name","subjects"), measure.vars = features_char[right_vars_feat])
deliverable_2 <- dcast(dmelt, subjects + activity_name ~variable, mean)
dim(deliverable_2)

# write the file 
write.csv(deliverable_2 , file="output.csv")

# test that everything ended up in the right place by comparing summarized
# (mean) values of the origional data (gg) and the final deliverable_2

gg <- y_sub_x_data
colnames(gg) <- c("activity_no","subjects", features_char)


test.data <- data.frame( l=1:(30*6*length(right_vars_feat)), 
                         i=NA, j=NA, k=NA, ggtest=NA, deltest=NA, 
                         passed = NA, ggvar = NA, ggvar_name=NA, 
                         delvar = NA, name_pass=NA)
keepers <- right_vars_feat + 2

i<-1  # column number 
j<-1  # subject number
k<-1  # activity number
l<-1  # ID number
for(i in seq_along(keepers)){
  for(j in 1:30) {
    for(k in 1:6) {
     
      test.data$l[l] <- l
      test.data$i[l] <- i
      test.data$j[l] <- j
      test.data$k[l] <- k
      test.data$ggtest[l] <- mean(gg[gg$subjects==j&gg$activity_no == k,keepers[i]]) 
      test.data$deltest[l] <- deliverable_2[deliverable_2$subjects==j
                 & deliverable_2$activity_name==activity.labels[k,2],i+2]
      test.data$passed[l] <- test.data$ggtest[l] == test.data$deltest[l]
      test.data$ggvar[l] <- keepers[i]
      test.data$ggvar_name[l] <- names(gg)[keepers[i]]
      test.data$delvar[l] <- names(deliverable_2)[i+2]
      test.data$name_pass[l] <- test.data$ggvar_name[l]==test.data$delvar[l] 
      l <- 1 + l
    }
  }
}

#summarize the test data
tmelt <- melt(test.data, id = c("i","j", "k"), measure.vars = c('passed','name_pass'))
#summarize the data looking for situations where the mean is not 1
t.cast <- dcast(tmelt, j + k ~variable, mean)
#display the results of those that are not correct (its a rounding error)
test.data[test.data$passed==FALSE,]$ggtest - test.data[test.data$passed==FALSE,]$deltest
#there is a percision error, 5 values are off by < 1.00*10^(-19)


