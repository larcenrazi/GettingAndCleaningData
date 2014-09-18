#setwd("C://RCodee//UCI HAR Dataset")
xtrain = read.table("./train/X_train.txt")
ytrain = read.table("./train/Y_train.txt")
xtest = read.table("./test/X_test.txt")
ytest = read.table("./test/Y_test.txt")
testSubject = read.table("./test/subject_test.txt")
trainSubject = read.table("./train/subject_train.txt")

#Get the headers names
features = read.table("./features.txt", sep="")
colNames = features[,2]

#Add headers to the test and train data
names(xtrain) <- colNames
names(xtest) <- colNames

#Merge the test and train data sets.
xfill<- rbind(xtrain,xtest)
yfill<- rbind(ytrain,ytest)
subjectfill<- rbind(trainSubject,testSubject)


#Extracts only the measurements on the mean and standard deviation for each
meansAndStd <-grep("*[m|M]ean*|*std*", colNames)

muAndStdSet <- xfill[ , meansAndStd ]


# 3. Uses descriptive activity names to name the activities in the data set

#Get Activity labels and set it to yfill then change the header name.
activityNames = read.table("./activity_labels.txt")
yfill[,1] <- activityNames[yfill[,1],2]

names(yfill) <- "activity"
names(subjectfill) <- "subject"

#4. Appropriately labels the data set with descriptive variable names.
#Merge all sets
mergedDataSet <- cbind(xfill, yfill, subjectfill)
#Make headers into lower case.
names(mergedDataSet) <- tolower(names(mergedDataSet))


#5. From the data set in step 4, creates a second, independent tidy data
#set with the average of each variable for each activity and each subject.
library(reshape2)
aql <- melt(mergedDataSet, id.vars = c("activity", "subject"))
aqw <- dcast(aql, activity + subject ~ variable, fun.aggregate = mean,
             na.rm = TRUE)

## write tidy dataset to disk

write.table(aqw, file="MyTideyData.txt", quote=FALSE, row.names=FALSE, sep="\t")
## write codebook to disk
write.table(paste("* ", names(tidy), sep=""), file="CodeBook.md", quote=FALSE,
row.names=FALSE, col.names=FALSE, sep="\t")
