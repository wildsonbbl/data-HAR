#First, look for variable names of the data of interest
features <- read.table(file = './UCI HAR Dataset/features.txt',
                       col.names = c('columnnumber','variable'))
ofinterest <- grep(pattern = '-mean[()]|-std[()]',x = features$variable)
features$variable <- tolower(gsub(pattern = '[-,()]',replacement = '',
                                  x = features$variable))

#load train data
subject_train <- read.table(file = './UCI HAR Dataset/train/subject_train.txt',
                            header = F, col.names = c('subject'),
                            colClasses = 'factor')
trainingset<-read.table(file = './UCI HAR Dataset/train/X_train.txt',
                        header = F, col.names = features$variable)
trainlabels<-read.table(file = './UCI HAR Dataset/train/Y_train.txt',
                        header = F,col.names = c('activity'))

#column bind subject, set and label
training <- cbind(subject_train,trainingset, trainlabels)

#load test data
subject_test <- read.table(file = './UCI HAR Dataset/test/subject_test.txt',
                           header = F, col.names = c('subject'),
                           colClasses = 'factor')
testset <- read.table(file = './UCI HAR Dataset/test/X_test.txt',
                      header = F, col.names = features$variable)
testlabels <- read.table(file = './UCI HAR Dataset/test/Y_test.txt',
                         header = F,col.names = c('activity'))

#column bind subject, set and label
test <- cbind(subject_test,testset, testlabels)

#row bind training and test tables
harset <- rbind(training,test)

#selecting columns of interest to THE har set
theharset <- harset[,rbind(c(1,'subject'),features[ofinterest,],
                           c(563,'activity'))$variable]

#function to change the labels to be more descriptive
changelabes <- function(label){
  activity_lables <- read.table(file = './UCI HAR Dataset/activity_labels.txt',
                                colClasses = c('integer','factor'))
  for(i in activity_lables[,1]){
    if(label == i){
      return(tolower(activity_lables[i,2]))
    }
  
  }
}

#changing the labels in the har set
theharset$activity <- sapply(X = theharset$activity,FUN = changelabes )


#checking to see if destination directory exists and creating it if it doesn't
if(!dir.exists('./theharset')){
  dir.create('./theharset')
}

#storing the har set in a nice and beautiful csv file
write.csv(x = theharset,file = './theharset/theharset.csv',row.names = F)

#checking to see if destination directory exists and creating it if it doesn't
if(!dir.exists('./theharset/averages')){
  dir.create('./theharset/averages')
}
#creating tables for each variable mean in subgroups subject and activity 
for(i in features[ofinterest,]$variable){
  temphar <- tapply(X = theharset[,i], 
                    INDEX = list(theharset$subject,theharset$activity), 
                    FUN = mean,simplify = T)
  temphar<-as.data.frame(cbind(subject = row.names(temphar),temphar))
  filepath <- paste0('./theharset/averages/',i,'.csv')
  write.csv(x = temphar,file = filepath,row.names = F)
}
