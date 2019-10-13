
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("Label", "Feature"))
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("Label", "Activity"))
YTrain <- read.table("./UCI HAR Dataset/train/Y_train.txt", col.names = "Label")
YTest <- read.table("./UCI HAR Dataset/test/Y_test.txt", col.names = "Label")
SubjTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
SubjTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
XTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
XTest <- read.table("./UCI HAR Dataset/test/X_test.txt")

df <- rbind(XTrain, XTest)
colnames(df) <- features$Feature

fMeanStd <- grepl("mean|std",features$Feature)
df <- df[,fMeanStd]

activities <- merge(rbind(YTrain, YTest), act_labels, by.x = "Label", by.y = "Label")
df <- cbind(rbind(SubjTrain, SubjTest), activities$Activity, df)

colnames(df)[2] <- "Activity"
colnames(df) <- sub("tBody","Time ",colnames(df))
colnames(df) <- sub("fBody","Freq ",colnames(df))
colnames(df) <- sub("tGravity","Time Grav ",colnames(df))
colnames(df) <- gsub("Body|\\(\\)","",colnames(df))
colnames(df) <- gsub("-"," ",colnames(df))

library(dplyr)
df <- tbl_df(df)

calcnames <- colnames(df)[-c(1,2)]

df %>% group_by(Subject, Activity) %>% 
      summarize_at(vars(calcnames), mean) %>%
      rename_at(-c(1,2), ~ paste0(., ' Avg')) %>%
      write.table("TidyDataAvg.txt", row.name=FALSE)


