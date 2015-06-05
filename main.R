library(data.table)
library(dplyr)
library(reshape2)
library(ggplot2)
library(stargazer)

options(na.action = na.omit)
options(digits = 4)

csv.files <- list.files("data/", pattern="*.csv", full.names = TRUE)

data <- data.table()

# data.list <- lapply(csv.files, fread)
data.list <- sapply(tail(csv.files, 4), function(f) { fread(f, colClasses=c("hhid"="character", "hhid2"="character")) }, simplify = FALSE, USE.NAMES = TRUE)
data <- rbindlist(data.list)

memory.limit(16000)
rm(data.list, csv.files)

data <- data[data$age > 25 & data$age < 55, ]
# data <- data[!is.na(data$w_ln_no)]

tmp <- data %>% group_by(year, wbho, educ) %>%
  summarise(mean.age=mean(age), empl=100*sum(empl, na.rm=T)/n(), selfemp=100*sum(selfemp, na.rm=T)/n(), selfinc=100*sum(selfinc, na.rm=T)/n(), unem=100*sum(unem, na.rm=T)/n(), earn=mean(w_ln_no, na.rm=T), hours=mean(uhoursi, na.rm=T)) %>%
  arrange(wbho, educ)

tmp.long <- melt(tmp, id.vars = c("year", "wbho", "educ"), measure.vars = c("earn"))

ggplot(data=tmp.long, aes(x=year, y=value, fill=variable, color=wbho)) +
  theme_bw() +
  geom_line() +
  facet_grid(. ~ educ)

# linear regression model with R2 - 0.2
reg <- lm(w_ln_no ~ wbho + educ + marstat + prcitshp + state, data=data)
stargazer(reg, type = "text")
summary(reg)

test <- lm(earn ~ wbho + educ, data=tmp)
stargazer(reg, test, type = "text")

# a number of lm with R2 ~ 0.9
reg.educ <- lm(earn ~ educ, data=tmp)
reg.hours <- lm(earn ~ hours, data=tmp)
reg.educ.hours <- lm(earn ~ educ + hours, data=tmp)
stargazer(reg.educ, reg.hours, reg.educ.hours, type="text")
