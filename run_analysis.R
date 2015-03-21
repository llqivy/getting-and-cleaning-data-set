setwd('C:\\Users\\Lingqian\\Documents\\R\\UCI HAR Dataset')

1. Merges the training and the test sets to create one data set.
## train data
#READ FILES
features=read.table('features.txt',header=FALSE)
activity=read.table('activity_labels.txt',header=FALSE)
sub_train=read.table('train/subject_train.txt',header=FALSE)
x_train=read.table('train/x_train.txt',header=FALSE)
y_train=read.table('train/y_train.txt',header=FALSE)

#Assinge column names
colnames(activity)=c('actID','actType')
colnames(sub_train)='subID'
colnames(x_train)=features[,2] 
colnames(y_train)='actID'

# merge data for train folder
DATA_train=cbind(y_train,sub_train,x_train);

# test data
sub_test =read.table('test/subject_test.txt',header=FALSE)
x_test=read.table('test/x_test.txt',header=FALSE)
y_test=read.table('test/y_test.txt',header=FALSE)

#Assinge column names
colnames(sub_test)='subID';
colnames(x_test)=features[,2]; 
colnames(y_test)='actID'

# merge data for test folder
DATA_test=cbind(y_test,sub_test,x_test);

# merge train data and test data
DATA=rbind(DATA_train,DATA_test)

2. Extract only the measurements on the mean and standard deviation for each measurement. 
index=(grepl("actID",colnames(DATA)) | grepl("subID",colnames(DATA)) | grepl("-mean..",colnames(DATA)) 
      & !grepl("-meanFreq..",colnames(DATA)) & !grepl("mean..-",colnames(DATA)) 
      | grepl("-std..",colnames(DATA)) & !grepl("-std()..-",colnames(DATA)))
data=DATA[index==TRUE]

3.Uses descriptive activity names to name the activities in the data set
data = merge(data,activity,by='actID',all.x=TRUE);


4.Appropriately labels the data set with descriptive variable names. 
colnames(data)[1]='activityID'
colnames(data)[2]='subjectID'
colnames(data)[3]='timeBodyAccMagnitudeMean'
colnames(data)[4]='timeBodyAccMagnitudeStdDev'
colnames(data)[5]='timeGravityAccMagnitudeMean'
colnames(data)[6]='timeGravityAccMagnitudeStdDev'
colnames(data)[7]='timeBodyAccJerkMagnitudeMean'
colnames(data)[8]='timeBodyAccJerkMagnitudeStdDev'
colnames(data)[9]='timeBodyGyroMagnitudeMean'
colnames(data)[10]='timeBodyGyroMagnitudeStdDev'
colnames(data)[11]='timeBodyGyroJerkMagnitudeMean'
colnames(data)[12]='timeBodyGyroJerkMagnitudeStdDev'
colnames(data)[13]='freqBodyAccMagnitudeMean'
colnames(data)[14]='freqBodyAccMagnitudeStdDev'
colnames(data)[15]='freqBodyAccJerkMagnitudeMean'
colnames(data)[16]='freqBodyAccJerkMagnitudeStdDev'
colnames(data)[17]='freqBodyGyroMagnitudeMean'
colnames(data)[18]='freqBodyGyroMagnitudeStdDev'
colnames(data)[19]='freqBodyGyroJerkMagnitudeMean'
colnames(data)[20]='freqBodyGyroJerkMagnitudeStdDev'
colnames(data)[21]='activityType'

5.Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
dataNoActivityType=data[,1:20];
data_mean= aggregate(dataNoActivityType[,3:20],by=list(activityID=dataNoActivityType$activityID,subjectID=dataNoActivityType$subjectID),mean);
data_mean= merge(data_mean,activity,by.x='activityID',by.y='actID',all.x=TRUE);
colnames(data_mean)[21]='activityType'

#Export the tidyData set 
write.table(data_mean, 'data_mean.txt',row.names=FALSE,sep='\t');