# Getting-and-Cleaning-Data-proj
Study Project for "Getting and Cleaning Data" course

File run_analysis.R description:
1) read all the parts of data set using read.table() function
2) Bind XTrain and XTest data into one data frame (df)
3) Assign column names to df
4) Find out all the columns with "mean" and "std" in their names
5) Remove unwanted columns from dataset
6) Prepare "activities" vector merging Activity labels with names
7) Bind dats frame with subjects and activity names
8) Change feature names with sub() and rsub() functions
9) - Using dplyr package group df data frame by subjects and activities
   - Summarize all features of df with mean() function
   - Add 'Avg' to the names of the features
10) Write new data frame to TidyDataAvg.txt file using write.table() function
