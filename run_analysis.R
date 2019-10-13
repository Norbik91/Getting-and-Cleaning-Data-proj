
# 1. read all the parts of data set using read.table() function
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("Label", "Feature"))
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("Label", "Activity"))
YTrain <- read.table("./UCI HAR Dataset/train/Y_train.txt", col.names = "Label")
YTest <- read.table("./UCI HAR Dataset/test/Y_test.txt", col.names = "Label")
SubjTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
SubjTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
XTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
XTest <- read.table("./UCI HAR Dataset/test/X_test.txt")

# 2. Bind XTrain and XTest data into one data frame (df)
df <- rbind(XTrain, XTest)

# 3. Assign column names to df
colnames(df) <- features$Feature

# 4. Find out all the columns with "mean" and "std" in their names
fMeanStd <- grepl("mean|std",features$Feature)

# 5. Remove unwanted columns from dataset
df <- df[,fMeanStd]

# 6. Prepare "activities" vector merging Activity labels with names
activities <- inner_join(rbind(YTrain, YTest), act_labels)

# 7. Bind dats frame with subjects and activity names
df <- cbind(rbind(SubjTrain, SubjTest), activities$Activity, df)

# 8. Change feature names with sub() and rsub() functions
colnames(df)[2] <- "Activity"
colnames(df) <- sub("tBody","Time ",colnames(df))
colnames(df) <- sub("fBody","Freq ",colnames(df))
colnames(df) <- sub("tGravity","Time Grav ",colnames(df))
colnames(df) <- gsub("Body|\\(\\)","",colnames(df))
colnames(df) <- gsub("-"," ",colnames(df))

# 9 Using dplyr package group df data frame by subjects and activities
library(dplyr)
df <- tbl_df(df)

calcnames <- colnames(df)[-c(1,2)]

df %>% group_by(Subject, Activity) %>% 
      
      # Summarize all features of df with mean() function
      summarize_at(vars(calcnames), mean) %>%
      
      # Add 'Avg' to the names of the features
      rename_at(-c(1,2), ~ paste0(., ' Avg')) %>%
      
      # Write new data frame to TidyDataAvg.txt file using write.table() function
      write.table("TidyDataAvg.txt", row.name=FALSE)


