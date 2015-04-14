fname <- "cepr_org_2013.dta"
  
# read sample data file to polish the data read & filter
data2013 <- read.dta(fname)

# age-based filter
data2013 <- subset(data2013, age > 25 & age < 55)

csv.fname <- gsub("dta", "csv", fname)

write.csv(data2013, file=csv.fname)
