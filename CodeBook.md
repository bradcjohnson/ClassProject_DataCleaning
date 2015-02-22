This document describes the steps required to complete the data processing for the Getting and Cleaning Data class project.

URL for compressed data file was provided.

1.  Download data files - run command in R environment:
      download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","prjdown.zip")
      Results in creation of file prjdown.zip in local environment.  
2.  Extract data files using SecureZip
3.  Examine
    - ReadMe.txt           	Provides an overview of the experiments performed,
    			   	  the nature of the data collected and the content 
    			   	  of each file in the .zip archive
    - features_info.txt    	Provides more detailed information on the nature of the observations
    			   	  and how the data elements result from the data collected 
    - features.txt   	   	Lists the data elements stored in the observation tables
    - activity_labels.txt  	Provides a key to the activity types that were observed
    - train/x_train.txt		The measurement data collected for the training group
    - test/x_test.txt		The measurement data collected for the test group
    - train/y_train.txt		The key values for the activities associated with each observation, training group
    - test/y_test.txt		The key values for the activities associated with each observation, test group
    - train/subject_train.txt	The numeric identifiers for the subjects associated with each observation, training group
    - test/subject/test.txt	The numeric identifiers for the subjects associated with each observation, test group
4.  Run script run_analysis.R
      Processing steps:
      - read data files
        features.txt
        activity_labels.txt
        train/x_train.txt
        test/x_test.txt
        train/y_train.txt
        test/y_test.txt
        train/subject_train.txt
        test/subject_test.txt    
      - combine test subject, activity and measurements
      - combine training subject, activity and measurements
      - merge tables
      - create table that includes only subject, activity and record identifiers
      - using table derived from activity_labels.txt, merge in column with descriptive activity names
      - using table derived from features.txt, extract mean and std variables from merged table, assign descriptive names
      - extract averages by measurement, activity and subject
      - write extract to text file in local environment