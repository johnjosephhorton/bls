library(dplyr)
library(quantmod)
library(lubridate)

message("[INFO] Getting inflation data from FRED.")

# inflation data
getSymbols("CPIAUCSL", src='FRED')
avg.cpi <- apply.yearly(CPIAUCSL, mean)
cf <- avg.cpi/as.numeric(avg.cpi['1991']) # using 1991 as the base year
cf <- as.data.frame(cf)
cf$year <- rownames(cf)
cf <- tail(cf, 25)
rownames(cf) <- NULL
cf$year <- year(as.Date(cf$year))
# end of inflation data get

rm(CPIAUCSL)
