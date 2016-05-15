

library(data.table)

# step 1. Merges the training and the test sets to create one data set.

# load Dataset including the test and training sets and the activities form web

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip", method = "auto")

# To unzip the folder
unzip("Dataset.zip")

# read table and screen data
testData <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
head(testData,3)

testData_act <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
head(testData_act,3)

testData_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
head(testData_sub,3)

trainData <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
head(trainData,3)

trainData_act <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
head(trainData_act,3)

trainData_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
head(testData,3)

# Use descriptive activity names to name the activities in the data set
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
testData_act$V1 <- factor(testData_act$V1,levels=activities$V1,labels=activities$V2)
trainData_act$V1 <- factor(trainData_act$V1,levels=activities$V1,labels=activities$V2)

# Appropriately labels the data set with descriptive activity names
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
head(features,2)
colnames(testData)<-features$V2
colnames(trainData)<-features$V2
colnames(testData_act)<-c("Activity")
colnames(trainData_act)<-c("Activity")
colnames(testData_sub)<-c("Subject")
colnames(trainData_sub)<-c("Subject")

# merge test and training sets into one data set, including the activities
testData<-cbind(testData,testData_act)
testData<-cbind(testData,testData_sub)
trainData<-cbind(trainData,trainData_act)
trainData<-cbind(trainData,trainData_sub)
bigData<-rbind(testData,trainData)
head(bigData,2)

# step 2. extract only the measurements on the mean and standard deviation for each measurement
bigData_mean<-sapply(bigData,mean,na.rm=TRUE)
bigData_sd<-sapply(bigData,sd,na.rm=TRUE)

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
DT <- data.table(bigData)
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy,file="tidy.txt",sep=",",row.names = FALSE)

str(tidy)
head(tidy,3)
tail(tidy,3)
summary(tidy)
