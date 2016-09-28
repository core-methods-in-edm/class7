data_wide <- read.table("~/class7/instructor_activity_wide.csv", sep = ",", header = TRUE)

#Now view the data you have uploaded and notice how its structure: each variable is a date and each row is a type of measure.
View(data_wide)

data_long <- gather(data_wide, date, variables)
#Rename the variables so we don't get confused about what is what!
names(data_long) <- c("variables", "date", "measure")
#Take a look at your new data, looks weird huh?
View(data_long)

instructor_data <- spread(data_long, variables, measure)

data_student <- read.table("~/class7/student_activity.csv", sep = ",", header = TRUE)
student_data <- spread(data_student, variable, measure)
View(student_data)

student_data_2 <- dplyr::filter(student_data, date == 20160204)

student_data_3 <- dplyr::filter(student_data, table == 4)

instructor_data <- dplyr::mutate(instructor_data, total_sleep = s_deep + s_light)

instructor_sleep <- dplyr::select(instructor_data, total_sleep)

instructor_data <- dplyr::mutate(instructor_data, week = dplyr::ntile(date, 3))

student_data <- dplyr::mutate(student_data, week = dplyr::ntile(date, 3))

student_data %>% dplyr::summarise(mean(motivation))

#That isn't super interesting, so let's break it down by week:

student_data %>% dplyr::group_by(date) %>% dplyr::summarise(mean(motivation))

student_week <- student_data %>%  dplyr::group_by(week) %>% dplyr::summarise(mean(motivation))
instructor_week <-  instructor_data %>%  dplyr::group_by(week) %>% dplyr::summarise(mean(m_active_time))

merge <- dplyr::full_join(instructor_week, student_week, "week")

z <- dplyr::select(merge, -week)
plot(z)

a <- dplyr::select(z, 1)
aa <-t(a)

b <- dplyr::select(z, 2)
bb <-t(b)
cor.test(aa,bb)
