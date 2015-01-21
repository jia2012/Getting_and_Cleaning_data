library(plyr)
setwd("/Users/shearora/insts/Getting_and_Cleaning_data/data")
###################################
# download the data
##################################

  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  zipfile="UCI_HAR_data.zip"
  download.file(url,destfile=zipfile,method="curl")
  
##################################
# Merge the dataset
#################################
# read training data and merge
training = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
training[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
training[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
dim(training)

# read and merge testing data
testing = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testing[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testing[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
dim(testing)
# merging training and testing data
merged.data <- rbind(training,testing)
dim(merged.data)

############################################
## Extract the mean and std values for the features
#############################################

# Read features and give better names for readability
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
head(features,n=7)
features[,2] = gsub('-mean', 'Mean', features[,2])
head(features,n=7)
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])
head(features,n=7)
dim(features)

# Get only the data on mean and std. dev.
colsWeWant <- grep(".*Mean.*|.*Std.*", features[,2])
head(colsWeWant)

# Reducing the feature tables to the one we want
features <- features[colsWeWant,]
head(features,n=7)

# Now add the last two columns (subject and activity)
colsWeWant <- c(colsWeWant, 562, 563)

# Remove the unwanted columns from merged data
merged.data <- merged.data[,colsWeWant]

# Add the column names (features) to merged data
colnames(merged.data) <- c(features$V2, "Activity", "Subject")
colnames(merged.data) <- tolower(colnames(merged.data))

# Read the activity labels
activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

currentActivity =1
for (currentActivityLabel in activityLabels$V2) {
  merged.data$activity <- gsub(currentActivity, currentActivityLabel, merged.data$activity)
  currentActivity <- currentActivity + 1
}
head(currentActivity)

merged.data$activity <- as.factor(merged.data$activity)
merged.data$subject <- as.factor(merged.data$subject)

tidy = aggregate(merged.data, by=list(activity = merged.data$activity, subject=merged.data$subject)
                 , mean)

# Remove the subject and activity column, since a mean of those has no use
tidy[,90] = NULL
tidy[,89] = NULL
head(tidy)
dim(tidy)

### Writing the text file.
write.table(tidy, "tidy.txt", sep="\t",row.name=FALSE)
