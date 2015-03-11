library(foreign)
library(dplyr)
library(reshape2)
library(tidyr)

options(na.action = na.omit)
options(digits = 4)

# read sample data file to polish the data read & filter
# data2012 <- read.dta("cepr_org_2012.dta")
# data2013 <- read.dta("cepr_org_2013.dta")

# age-based filter
# data2013 <- subset(data2013, age > 25 & age < 55)

obs.total <- length(data2013$age)
# length(data2013$empl[data2012$empl])

# empl, unem, selfemp, selfinc

# all.age <- mean(data2013$age)
# sal.age <- mean(data2013[data2013$empl == 1, ]$age, na.rm=T)
# semp.all.age <- mean(data2013[data2013$selfemp == 1 | data2013$selfinc == 1, ]$age, na.rm=T)
# semp.uninc.age <- mean(data2013[data2013$selfemp == 1, ]$age, na.rm=T)
# semp.inc.age <- mean(data2013[data2013$selfinc == 1, ]$age, na.rm=T)

field.summary.v2 <- function(data_set, field, value, pre.function, post.function) {
  # subsetting the desired data
  # input NA for 'value' if no presubsetting needed
  data <- if(is.na(value)) data_set else data_set[data_set[field] == value, ]
  
  all <- pre.function(data[, field])
  sal <- pre.function(data[data$empl == 1, ][, field])
  semp.all <- pre.function(data[data$selfemp == 1 | data$selfinc == 1, ][, field])
  semp.uninc <- pre.function(data[data$selfemp == 1, ][, field])
  semp.inc <- pre.function(data[data$selfinc == 1, ][, field])
  
  return(post.function(all, sal, semp.all, semp.uninc, semp.inc))
}

print(c("Age:", field.summary.v2(data2013, "age", NA, function(x) { return(mean(x, na.rm=T)) }, c)))

total.part <- function(...) {
  return(c(...) / obs.total)
}

print("Races:")
print(c("White: ", field.summary.v2(data2013, "wbho", "White", nrow, total.part)))
print(c("Hispanic: ", field.summary.v2(data2013, "wbho", "Hispanic", nrow, total.part)))
print(c("Black: ", field.summary.v2(data2013, "wbho", "Black", nrow, total.part)))

print("Degree")
print(c("Advanced: ", field.summary.v2(data2013, "educ", "Advanced", nrow, total.part)))
print(c("College: ", field.summary.v2(data2013, "educ", "College", nrow, total.part)))
print(c("HS: ", field.summary.v2(data2013, "educ", "HS", nrow, total.part)))
print(c("LTHS: ", field.summary.v2(data2013, "educ", "LTHS", nrow, total.part)))
print(c("Some college: ", field.summary.v2(data2013, "educ", "Some college", nrow, total.part)))

# field.summary <- function(data_set, field, value) {
#   obs.total <- length(data_set$age)
#   data <- data_set[data_set[field] == value, ]
#   
#   all <- length(data$age)
#   sal <- length(data[data$empl == 1, ]$age)
#   semp.all <- length(data[data$selfemp == 1 | data$selfinc == 1, ]$age)
#   semp.uninc <- length(data[data$selfemp == 1, ]$age)
#   semp.inc <- length(data[data$selfinc == 1, ]$age)
#   
#   return(c(all, sal, semp.all, semp.uninc, semp.inc) / obs.total)
# }

# all.white <- length(data2013[data2013$wbho == "White", ]$age) / obs.total
# sal.white <- length(data2013[data2013$wbho == "White" & data2013$empl == 1, ]$age) / obs.total
# semp.all.white <- length(data2013[data2013$wbho == "White" & (data2013$selfemp == 1 | data2013$selfinc == 1), ]$age) / obs.total
# semp.uninc.white <- length(data2013[data2013$wbho == "White" & data2013$selfemp == 1, ]$age) / obs.total
# semp.inc.white <- length(data2013[data2013$wbho == "White" & data2013$selfinc == 1, ]$age) / obs.total

# print(c("White: ", field.summary(data2013, "wbho", "White")))
# print(c("Hispanic: ", field.summary(data2013, "wbho", "Hispanic")))
# print(c("Black: ", field.summary(data2013, "wbho", "Black")))

# educ
# Advanced, College, HS, LTHS, Some college
# print("Degree")
# print(c("Advanced: ", field.summary(data2013, "educ", "Advanced")))
# print(c("College: ", field.summary(data2013, "educ", "College")))
# print(c("HS: ", field.summary(data2013, "educ", "HS")))
# print(c("LTHS: ", field.summary(data2013, "educ", "LTHS")))
# print(c("Some college: ", field.summary(data2013, "educ", "Some college")))

# aggregated_data <- melt(mydf, id.vars="Group")
# Match <- c(Wk1 = 1, Wk2 = 1, Wk3 = 2, Wk4 = 3, Wk5 = 3, Wk6 = 4)
# aggregate(value ~ Match[X$variable], X, mean)

# attach(data2013)

# aggregate(data2013, by=list(empl, unem, selfemp, selfinc), FUN=mean)

# detach(data2013)
