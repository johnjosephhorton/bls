library(data.table)

csv.files <- list.files("data/", pattern="*.csv")
csv.files <- paste0("data/", csv.files)

data <- data.table()

# for(f in fnames) {
#   tmp <- 
# }

data.list <- lapply(csv.files, fread)
data <- rbindlist(data.list)
