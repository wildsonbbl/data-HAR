---
title: "README"
author: "Wildson B B Lima"
date: "19/10/2020"
output: html_document
---

Analysis
====
**Downloaded UCI HAR Dataset [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) **   

The script has the following flow:  

* Looks for the variable names of interest in the `features.txt` file, that is the means and standard deviations   
* Load and bind train and test set with proper column names  
* Select the variables of interest from previously bind dataset
* Uses a function to make activity names more descriptive  
* Stores the tidy dataset in a csv file  
* Creates and stores new datasets with the mean of each variable of interest grouped by subject and activity
