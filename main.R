library("foreign")

# read sample data file to polish the data read & filter
data <- read.dta("cepr_org_2013.dta")

# age-based filter
data <- subset(data, age > 25 & age < 55)
