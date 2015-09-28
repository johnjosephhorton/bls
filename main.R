library(data.table)
library(dplyr)
library(reshape2)
library(ggplot2)
library(stargazer)

tmp <- data %>% group_by(year, wbhao, educ) %>%
  summarise(mean.age=mean(age), empl=100*sum(empl, na.rm=T)/n(), selfemp=100*sum(selfemp, na.rm=T)/n(), selfinc=100*sum(selfinc, na.rm=T)/n(), unem=100*sum(unem, na.rm=T)/n(), earn=mean(w_ln_no, na.rm=T), hours=mean(uhoursi, na.rm=T)) %>%
  arrange(wbhao, educ)

tmp <- tmp[educ != ""]

source("inflation.R")
tmp <- tmp %>% inner_join(cf, by = "year", copy = T) %>% mutate(infl.earn = earn / CPIAUCSL)

tmp.long <- melt(tmp, id.vars = c("year", "wbhao", "educ"), measure.vars = c("infl.earn"))

install.packages("extrafont")
library(extrafont)

font_import(pattern="consola", prompt = F)
fonts()
fonttable()

ggplot(data=tmp.long, aes(x=year, y=value, fill=variable, color=wbhao)) +
  theme_bw() +
  geom_line() +
  facet_grid(. ~ educ) +
  theme(text=element_text(size=16, family="Consolas"))

# for(i in 2013:1991) {
#   reg <- lm(w_ln_no ~ wbhaom + educ + marstat + prcitshp + state, data=data[year == i])
#   reg_name <- paste0("output/regressions/earn_multiple_regression_", i, ".md")
#   stargazer(reg, type = "text", out = reg_name)
#   
#   reg.educ <- lm(earn ~ educ, data=tmp[year == i])
#   reg.educ_name <- paste0("output/regressions/mean_earn_educ_", i, ".md")
#   stargazer(reg.educ, type = "text", out = reg.educ_name)
# }
