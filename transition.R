library(data.table)
library(reshape2)
library(stringr)

data2012 <- fread("data/cepr_org_2012.csv", colClasses=c("hhid"="character", "hhid2"="character"))
data2013 <- fread("data/cepr_org_2013.csv", colClasses=c("hhid"="character", "hhid2"="character"))

sub.data2013 <- data2013[, .(year, month, hhid, hhid2, age, lfstat, empl, unem, nilf, selfemp, selfinc)]
sub.data2012 <- data2012[, .(year, month, hhid, hhid2, age, lfstat, empl, unem, nilf, selfemp, selfinc)]

sub.data2012$hh <- with(sub.data2012, paste0(hhid, hhid2, ".", year, ".", age))
sub.data2013$hh <- with(sub.data2013, paste0(hhid, hhid2, ".", year, ".", age))

merged.data <- rbind(sub.data2012, sub.data2013)
merged.data <- merged.data[complete.cases(merged.data), ]

merged.data <- merged.data[order(merged.data$hh), ]

res <- data.frame(t(apply(merged.data[-1], 1, function(x) names(merged.data[-1])[x != 0])))
dcast(res, X1 ~ X2)