library(data.table)
library(dplyr)
library(reshape2)
library(tidyr)

options(na.action = na.omit)
options(digits = 4)

# load necessary functions
source("helpers.R")

if(!exists("data2013")) {
  data2013 <- fread("data/cepr_org_2013.csv", colClasses=c("hhid"="character", "hhid2"="character"))
}

data2012 <- fread("data/cepr_org_2012.csv", colClasses=c("hhid"="character", "hhid2"="character"))
data2013 <- fread("data/cepr_org_2013.csv", colClasses=c("hhid"="character", "hhid2"="character"))

obs.total <- length(data2013$age)
# length(data2013$empl[data2012$empl])

# empl, unem, selfemp, selfinc

print(c("Age:", field.summary.v2(data2013, "age", NA, function(x) { return(mean(x, na.rm=T)) }, c)))

print("Races:")
print(c("White: ", field.summary.v2(data2013, "wbho", "White", length, total.part)))
print(c("Hispanic: ", field.summary.v2(data2013, "wbho", "Hispanic", length, total.part)))
print(c("Black: ", field.summary.v2(data2013, "wbho", "Black", length, total.part)))

print("Degree")
print(c("Advanced: ", field.summary.v2(data2013, "educ", "Advanced", length, total.part)))
print(c("College: ", field.summary.v2(data2013, "educ", "College", length, total.part)))
print(c("HS: ", field.summary.v2(data2013, "educ", "HS", length, total.part)))
print(c("LTHS: ", field.summary.v2(data2013, "educ", "LTHS", length, total.part)))
print(c("Some college: ", field.summary.v2(data2013, "educ", "Some college", length, total.part)))
