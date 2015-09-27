# Getting and Clearning Data
# You should create one R script called run_analysis.R that does the following. 
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# get data
lbl <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
ft <- read.table("./UCI HAR Dataset/features.txt")[,2]
xte <- read.table("./UCI HAR Dataset/test/X_test.txt")
yte <- read.table("./UCI HAR Dataset/test/y_test.txt")
ste <- read.table("./UCI HAR Dataset/test/subject_test.txt")
xtr <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytr <- read.table("./UCI HAR Dataset/train/y_train.txt")
stra <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# labels
names(xte) = ft
names(xtr) = ft
yte[,2] = lbl[yte[,1]]
names(yte) = c("Activity_ID", "Activity_Label")
names(ste) = "subject"
ytr[,2] = lbl[ytr[,1]]
names(ytr) = c("Activity_ID", "Activity_Label")
names(stra) = "subject"

# get only the mean and standard deviation from features
pull_features <- grepl("mean|std", ft)
xte = xte[,pull_features]
xtr = xtr[,pull_features]

# combine date
test_data <- cbind(ste,yte,xte)
train_data <- cbind(stra,ytr,xtr)
data = rbind(test_data, train_data)

# melt data
lbls = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), lbls)
melt_data = melt(data, id = lbls, measure.vars = data_labels)

# mean function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

# write table
write.table(tidy_data, file = "./tidy_data.txt")
