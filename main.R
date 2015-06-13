library(data.table)
library(dplyr)
library(reshape2)
library(ggplot2)
library(stargazer)

options(na.action = na.omit)
options(digits = 4)

csv.files <- list.files("data/", pattern="cepr_org_[[:digit:]]{4}\\.csv", full.names = TRUE)

data <- data.table()

# data.list <- lapply(csv.files, fread)
data.list <- sapply(csv.files, function(f) { fread(f, colClasses=c("hhid"="character", "hhid2"="character")) }, simplify = FALSE, USE.NAMES = TRUE)
data <- rbindlist(data.list)

rm(data.list, csv.files)

data <- data[data$age > 25 & data$age < 55, ]
# data <- data[!is.na(data$w_ln_no)]

tmp <- data %>% group_by(year, wbho, educ) %>%
  summarise(mean.age=mean(age), empl=100*sum(empl, na.rm=T)/n(), selfemp=100*sum(selfemp, na.rm=T)/n(), selfinc=100*sum(selfinc, na.rm=T)/n(), unem=100*sum(unem, na.rm=T)/n(), earn=mean(w_ln_no, na.rm=T), hours=mean(uhoursi, na.rm=T)) %>%
  arrange(wbho, educ)

tmp <- tmp[educ != ""]

source("inflation.R")
tmp <- tmp %>% inner_join(cf, by = "year", copy = T) %>% mutate(infl.earn = earn / CPIAUCSL)

tmp.long <- melt(tmp, id.vars = c("year", "wbho", "educ"), measure.vars = c("infl.earn"))

ggplot(data=tmp.long, aes(x=year, y=value, fill=variable, color=wbho)) +
  theme_bw() +
  geom_line() +
  facet_grid(. ~ educ)

for(i in 2013:1991) {
  reg <- lm(w_ln_no ~ wbho + educ + marstat + prcitshp + state, data=data[year == i])
  reg_name <- paste0("output/regressions/earn_multiple_regression_", i, ".md")
  stargazer(reg, type = "text", out = reg_name)
  
  reg.educ <- lm(earn ~ educ, data=tmp[year == i])
  reg.educ_name <- paste0("output/regressions/mean_earn_educ_", i, ".md")
  stargazer(reg.educ, type = "text", out = reg.educ_name)
}
