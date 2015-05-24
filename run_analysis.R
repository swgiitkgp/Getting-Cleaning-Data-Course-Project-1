run_analysis <- function()
{
  
library(plyr)

#Merging Training and Test data sets to create a single data set
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
#Reading Test Data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Combining training and test datasets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

#Extracting mean and std. deviation for each measurement
#Extracting cols with mean() or std() in their names
features <- read.table("UCI HAR Dataset/features.txt")
mean_and_std_dev <- grep("-(mean|std)\\(\\)", features[, 2])

#Subset desired cols of x_data
x_data <- x_data[, mean_and_std_dev]
#Correcting the col names
names(x_data) <- features[mean_and_std_dev, 2]

#Using activity names to name the activities in data
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
y_data[, 1] <- activity_labels[y_data[, 1], 2]
names(y_data) <- "activity"   #Correcting col name


#Label datasets with label names
names(subject_data) <- "subject"
#Binding data into a single data set
all_data <- cbind(x_data, y_data, subject_data)

#Creating another tidy data set with averages of variables for each activity, subject
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)


}