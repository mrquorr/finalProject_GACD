# 1. Merges the training and the test sets to create one data set.
train <- read.table("UCI HAR Dataset/train/X_train.txt")
trlab <- scan("UCI HAR Dataset/train/y_train.txt")
trsub <- scan("UCI HAR Dataset/train/subject_train.txt")

test <- read.table("UCI HAR Dataset/test/X_test.txt")
tslab <- scan("UCI HAR Dataset/test/y_test.txt")
tssub <- scan("UCI HAR Dataset/test/subject_test.txt")

train["activity_code"] <- trlab
train["subject_code"] <- trsub
test["activity_code"] <- tslab
test["subject_code"] <- tssub

dataset <- rbind(train, test)

# 4. Appropriately labels the data set with descriptive variable names. 
varNames <- read.table("UCI HAR Dataset/features.txt")
strNames <- as.character(varNames$V2)
strNames[562] <- "activity_code"
strNames[563] <- "subject_code"
names(dataset) <- strNames

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#colMeans(dataset) # better format than lapply
#lapply(dataset, sd)
avgs <- grep('mean', names(dataset))
stds <- grep('std', names(dataset))
cods <- grep('code', names(dataset))
toextract <- append(avgs, stds)
toextract <- append(toextract, cods)
relevant <- dataset[,toextract]

# 3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activities) <- c("activity_code", "activity_name")
relevant <- merge(relevant, activities, by.x="activity_code", by.y="activity_code", all.x = TRUE)
relevant <- select(relevant, -activity_code)

# 5. From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.
tidy <- relevant %>% 
group_by(activity_name, subject_code) %>% 
summarise_each(funs(mean))
