library(data.table)

csv.files <- list.files("data/", pattern="*.csv", full.names = TRUE)

data <- data.table()

data.list <- lapply(csv.files, fread)
data <- rbindlist(data.list)
