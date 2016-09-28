#Opening data set
data_wide <- read.table("C:/Users/lfaf373/Documents/RStudioProj/cLASS7/instructor_activity_wide.csv", sep = ",", header = TRUE)
#Now view the data you have uploaded and notice how its structure: each variable is a date and each row is a type of measure.
View(data_wide)
# opening the library of these two packages to tidy data
library(tidyr, dplyr)
#R doesn't like having variable names that consist only of numbers so, as you can see, every variable starts with the letter "X". The numbers represent dates in the format year-month-day.
#this converts wide to long->> by date
data_long <- gather(data_wide, date, variables)
#Rename the variables so we don't get confused about what is what!
names(data_long) <- c("variables", "date", "measure")
#Take a look at your new data, looks weird huh?
View(data_long)
# Converting long format into seperate columns, seperating by type of measure
instructor_data <- spread(data_long, variables, measure)
# upload student data
student_data<- read.csv("C:/Users/lfaf373/Documents/RStudioProj/cLASS7/student_activity.csv")
# first we have to make sure r knows to use dplyr command
# Here we are only including data from the second clas
student_data_2 <- dplyr::filter(student_data, date == 20160204)
# Here we are only including data from students who sat at table 4
# Subsetted from the original dataset
student_data_3 <- dplyr::filter(student_data, variable == "table" & measure == 4)
# usinging mutate to make a new variable, total sleep... which is lite plus deep sleep
instructor_data <- dplyr::mutate(instructor_data, total_sleep = s_deep + s_light)
#making a new data frame that only includes total_sleep 
instructor_sleep<- dplyr::select(instructor_data, total_sleep)
# create a grouping variable called week
# for some reason, there are 8 days in week 1
instructor_data <- dplyr::mutate(instructor_data, week = dplyr::ntile(date, 3))
# Same as above but for stduent
student_data <- dplyr::mutate(student_data, week = dplyr::ntile(date, 3))
#
# motivation <- dplyr::filter(student_data, variable == "motivation")
# Summarize data
dplyr::summarise(student_data, avg=mean(variable))

#That isn't super interesting, so let's break it down by week:

student_data %>% dplyr::group_by(date) %>% dplyr::summarise(mean(motivation))
