# read sample data file to polish the data read & filter
# data2012 <- read.dta("cepr_org_2012.dta")
data2013 <- read.dta("cepr_org_2013.dta")

# age-based filter
data2013 <- subset(data2013, age > 25 & age < 55)
