        library(reshape2)
        
        ## checking data availability, downloading dataset, unzipping 
        ##
        filename <- "getdata-projectfiles-UCI HAR Dataset.zip"

        if (!file.exists(filename)){
                fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                download.file(fileURL, filename, method="curl")
        }  
        if (!dir.exists("UCI HAR Dataset")) { 
                unzip(filename) 
        }
        #
        # reading data labels and features 
        #
        tmp <- read.table("./UCI HAR Dataset/activity_labels.txt")
        activity_labels <- tmp
        activity_labels[,2] <- as.character(activity_labels[,2])
        
        tmp <- read.table("./UCI HAR Dataset/features.txt")
        features <- as.character(tmp[,2])
        #
        # reading training dataset 
        # 
        trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")
        trainDatalabels <- read.table("./UCI HAR Dataset/train/y_train.txt")
        subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
        
        #
        # Reading test dataset 
        #
        testData <- read.table("./UCI HAR Dataset/test/X_test.txt")
        testDatalabels <- read.table("./UCI HAR Dataset/test/y_test.txt")
        subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
        
        # 1) Merge the two dataset 
        DataAll <-  rbind(trainData, testData)
        subjectAll <- rbind(subject_train, subject_test)
        Datalabels <- rbind(trainDatalabels, testDatalabels) 
        Datalabels[,2] <-  activity_labels[Datalabels[,1],2]
        
        
        
        
        ##extract_features <- grepl("mean|std", features)
        
        extractFeatures <- grep(".*mean.*|.*std.*", features)
        extractFeatures.names <- features[extractFeatures]
        
       
        
        names(DataAll) <-  features
        colnames(Datalabels) <- c("ActivityID", "Activity")
        colnames(subjectAll) <- "Subject"
        
        
        # Extract only the measurements on the mean and standard deviation 
        Datain <- DataAll[,extractFeatures]
       
        # Bind data
        Data1 <- cbind(as.data.table(subjectAll), Datalabels , Datain)
        
        IDLabels   <-  c("Subject","ActivityID", "Activity")
        MesLabels <-  setdiff(colnames(Data1), IDLabels)
        meltData   <-  melt(Data1, id = IDLabels, measure.vars = MesLabels)
        tidyData  <-  dcast(meltData, Subject + Activity ~ variable, mean)
        write.table(tidyData, file = "./tidy.txt", row.names = FALSE, quote = FALSE)
        
        
  
        
        
        
        
        