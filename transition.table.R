library(data.table)
library(reshape2)
library(dplyr)

empl.empl <- 0
empl.unem <- 0
empl.selfemp <- 0
empl.selfinc <- 0
empl.total <- 0

unem.empl <- 0
unem.unem <- 0
unem.selfemp <- 0
unem.selfinc <- 0
unem.total <- 0

selfemp.empl <- 0
selfemp.unem <- 0
selfemp.selfemp <- 0
selfemp.selfinc <- 0
selfemp.total <- 0

selfinc.empl <- 0
selfinc.unem <- 0
selfinc.selfemp <- 0
selfinc.selfinc <- 0
selfinc.total <- 0

total <- 0

transit <- function(from, to) {
  if(prev[[from]] == 1 & cur[[to]] == 1) {
    name <- paste(from, to, sep = ".")
    val <- get(name, envir = globalenv())
    assign(name, val + 1, envir = globalenv())
    
    total <- paste(from, "total", sep = ".")
    val <- get(total, envir = globalenv())
    assign(total, val + 1, envir = globalenv())
  }
}

library(utils)

hh2012 <- merged.data[year == 2012, hh]
pb <- txtProgressBar(0, length(hh2012), 0, style = 3)

system.time(for(i in hh2012) {
  sub <- merged.data[hh == i, ]
  
  setTxtProgressBar(pb, total)
  total <- total + 1
  
  if(nrow(sub) != 2) {
    next
  }
  if(length(unique(sub$year)) != 2) {
    next
  }
  
  prev <- sub[year == 2012]
  cur <- sub[year == 2013]
  
  transit("empl", "empl")
  transit("empl", "unem")
  transit("empl", "selfemp")
  transit("empl", "selfinc")
  
  transit("unem", "empl")
  transit("unem", "unem")
  transit("unem", "selfemp")
  transit("unem", "selfinc")
  
  transit("selfemp", "empl")
  transit("selfemp", "unem")
  transit("selfemp", "selfemp")
  transit("selfemp", "selfinc")
  
  transit("selfinc", "empl")
  transit("selfinc", "unem")
  transit("selfinc", "selfemp")
  transit("selfinc", "selfinc")
})

transition <- matrix(c(empl.empl, empl.unem, empl.selfemp, empl.selfinc,
                unem.empl, unem.unem, unem.selfemp, unem.selfinc, 
                selfemp.empl, selfemp.unem, selfemp.selfemp, selfemp.selfinc,
                selfinc.empl, selfinc.unem, selfinc.selfemp, selfinc.selfinc),
                nrow = 4,
                ncol = 4)

start.total <- unlist(lapply(c("empl", "unem", "selfemp", "selfinc"), function(x) nrow(merged.data[year == 2012 & merged.data[[x]] == 1, ])))
start.total <- c(empl.total, unem.total, selfemp.total, selfinc.total)

transition.from.to <- 100 * apply(t(transition), 1, "/", start.total)
