library(foreign)
library(data.table)

fname <- list.files("origin/")
fname <- paste0("origin/", fname)

for(f in fname) {
  print(f)
  data <- read.dta(f)
  data <- subset(data, age > 25 & age < 55)
  
  csv.fname <- gsub("dta", "csv", basename(f))
  csv.fname <- paste0("data/", csv.fname)
  
  # write.csv(data, file=csv.fname)
}
