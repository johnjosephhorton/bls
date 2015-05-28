library(data.table)
library(dplyr)
library(reshape2)
library(ggplot2)

options(na.action = na.omit)
options(digits = 4)

# load necessary functions
source("helpers.R")

if(!exists("data2012")) {
  data2012 <- fread("data/cepr_org_2012.csv", colClasses=c("hhid"="character", "hhid2"="character"))
}

if(!exists("data2013")) {
  data2013 <- fread("data/cepr_org_2013.csv", colClasses=c("hhid"="character", "hhid2"="character"))
}

# summarise of empl, unem, selfemp, selfinc based on educ (Education) and wbho (Race)
educ.wbho.summ <- group_by(data2012, wbho, educ) %>%
  summarise(mean.age=mean(age), empl=100*sum(empl, na.rm=T)/n(), selfemp=100*sum(selfemp, na.rm=T)/n(), selfinc=100*sum(selfinc, na.rm=T)/n(), unem=100*sum(unem, na.rm=T)/n(), earn) %>%
  arrange(wbho, educ)
