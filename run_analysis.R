library(dplyr)

# read activity and features and set names
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

names(activities) <- c("id", "activity")

# read training data and set names
trainingSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
trainingValue <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainingActivity <- read.table("./UCI HAR Dataset/train/y_train.txt")
names(trainingSubject) <- "subject"
names(trainingValue) <- features[,2]
names(trainingActivity) <- "activity"

# read test data and set names
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
testValue <- read.table("./UCI HAR Dataset/test/X_test.txt")
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt")
names(testSubject) <- "subject"
names(testValue) <- features[,2]
names(testActivity) <- "activity"



#combine data sets
combinedTraining <- cbind(trainingSubject,trainingActivity,trainingValue)
combinedTest <- cbind(testSubject, testActivity,testValue)

combinedData <- rbind(combinedTraining,combinedTest)

#find columns with sd and mean
targetColumns <- grepl("mean|std", colnames(combinedData))
masterData <- data.frame(combinedData[,1:2])
masterData <- cbind(masterData, combinedData[,targetColumns])

#assign factor names to activity
masterData$activity <- factor(masterData$activity,levels = activities[, 1], labels = activities[, 2])


#group by subject and activity and then calculate the mean
finalData <- masterData %>% 
    group_by(subject, activity) %>%
    summarise_all(funs(mean))

#write clean file
write.csv(finalData,"./cleanData.csv")
