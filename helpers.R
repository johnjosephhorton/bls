field.summary.v2 <- function(data_set, field, value, pre.function, post.function) {
  # subsetting the desired data
  # input NA for 'value' if no presubsetting needed
  data <- if(is.na(value)) data_set else data_set[data_set[, field] == value, ]
  
  all <- pre.function(data[, field])
  sal <- pre.function(data[data$empl == 1, ][, field])
  semp.all <- pre.function(data[data$selfemp == 1 | data$selfinc == 1, ][, field])
  semp.uninc <- pre.function(data[data$selfemp == 1, ][, field])
  semp.inc <- pre.function(data[data$selfinc == 1, ][, field])
  
  return(post.function(all, sal, semp.all, semp.uninc, semp.inc))
}

total.part <- function(...) {
  return(c(...) / obs.total)
}