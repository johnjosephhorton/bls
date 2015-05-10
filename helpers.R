field.summary.v2 <- function(data_set, field, value, pre.function, post.function) {
  # subsetting the desired data
  # input NA for 'value' if no presubsetting needed
  data <- if(is.na(value)) data_set else data_set[data_set[, get(field)] == value, ]
  
  all <- data[, pre.function(get(field))]
  sal <- data[data$empl == 1, pre.function(get(field))]
  semp.all <- pre.function(data[data$selfemp == 1 | data$selfinc == 1, get(field)])
  semp.uninc <- pre.function(data[data$selfemp == 1, get(field)])
  semp.inc <- pre.function(data[data$selfinc == 1, get(field)])
  
  return(post.function(all, sal, semp.all, semp.uninc, semp.inc))
}

total.part <- function(...) {
  return(c(...) / obs.total)
}
