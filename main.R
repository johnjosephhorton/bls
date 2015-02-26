library(foreign)
library(dplyr)
library(reshape2)
library(tidyr)

options(na.action = na.omit)

# read sample data file to polish the data read & filter
# data2012 <- read.dta("cepr_org_2012.dta")
data2013 <- read.dta("cepr_org_2013.dta")

# age-based filter
data2013 <- subset(data2013, age > 25 & age < 55)

# length(data2013$empl[data2013$empl])
# length(data2013$empl[data2012$empl])

# empl, unem, selfemp, selfinc

all.age <- mean(data2013$age)
sal.age <- mean(data2013[data2013$empl == 1, ]$age, na.rm=T)
semp.all.age <- mean(data2013[data2013$selfemp == 1 | data2013$selfinc == 1, ]$age, na.rm=T)
semp.uninc.age <- mean(data2013[data2013$selfemp == 1, ]$age, na.rm=T)
semp.inc.age <- mean(data2013[data2013$selfinc == 1, ]$age, na.rm=T)

# aggregated_data <- melt(mydf, id.vars="Group")
# Match <- c(Wk1 = 1, Wk2 = 1, Wk3 = 2, Wk4 = 3, Wk5 = 3, Wk6 = 4)
# aggregate(value ~ Match[X$variable], X, mean)

# attach(data2013)

# aggregate(data2013, by=list(empl, unem, selfemp, selfinc), FUN=mean)

# detach(data2013)
