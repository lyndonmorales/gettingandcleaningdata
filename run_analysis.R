# load dplyr package
library(dplyr)

# read test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Subj_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# read train data 
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Subj_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# read data features
features_names <- read.table("./UCI HAR Dataset/features.txt")

# read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# 1. Merges the training and the test sets to create one data set.
X_bind <- rbind(X_train, X_test)
Y_bind <- rbind(Y_train, Y_test)
Subj_total <- rbind(Subj_train, Subj_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
extracted_var <- features_names[grep("mean\\(\\)|std\\(\\)",features_names[,2]),]
X_bind <- X_bind[,extracted_var[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(Y_bind) <- "activity"
Y_bind$activitylabel <- factor(Y_bind$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_bind[,-1]

# 4. Appropriately labels the data set with descriptive variable names.
colnames(X_bind) <- features_names[extracted_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(Subj_total) <- "subject"
total <- cbind(X_bind, activitylabel, Subj_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydataset.txt", row.names = FALSE, col.names = TRUE)