library(data.table)
library(dplyr)
library(reshape2)
library(ggplot2)

options(na.action = na.omit)
options(digits = 4)

csv.files <- list.files("data/", pattern="*.csv", full.names = TRUE)

data <- data.table()

# data.list <- lapply(csv.files, fread)
data.list <- sapply(tail(csv.files, 4), function(f) { fread(f, colClasses=c("hhid"="character", "hhid2"="character")) }, simplify = FALSE, USE.NAMES = TRUE)
data <- rbindlist(data.list)

memory.limit(16000)
rm(data.list)

data <- data[data$age > 25 & data$age < 55, ]

tmp <- group_by(data, year, wbho, educ) %>%
  summarise(mean.age=mean(age), empl=100*sum(empl, na.rm=T)/n(), selfemp=100*sum(selfemp, na.rm=T)/n(), selfinc=100*sum(selfinc, na.rm=T)/n(), unem=100*sum(unem, na.rm=T)/n(), earn=mean(w_ln_no, na.rm=T)) %>%
  arrange(wbho, educ)

tmp.long <- melt(tmp, id.vars = c("year", "wbho", "educ"), measure.vars = c("earn"))

ggplot(data=tmp.long, aes(x=year, y=value, fill=variable, color=wbho)) +
  theme_bw() +
  geom_line() +
  facet_grid(. ~ educ)
