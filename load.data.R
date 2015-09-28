library(data.table)
library(dplyr)

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
