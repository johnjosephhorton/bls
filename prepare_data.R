library(rvest)

data_url <- "http://ceprdata.org/cps-uniform-data-extracts/cps-outgoing-rotation-group/cps-org-data/"
html <- html(data_url)

zips <- html %>% html_nodes(xpath = "//div[@class='content']/ul/li/a") %>% html_attr(name="href")

print(zips)
