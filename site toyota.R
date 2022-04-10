install.packages("RSelenium")
install.packages("rvest")
install.packages("stringr")
install.packages("xml2")

library(RSelenium)
library(rvest)
library(stringr)
library(xml2)

try(rsDriver(port=4444L,browser='firefox'))

remDr<-remoteDriver() 
remDr$open()
remDr$navigate("https://www.toyota.ca/toyota/en/vehicles/rav4/overview")


Sys.sleep(5)  


webElem <- remDr$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))  

Sys.sleep(5)
html <- remDr$getPageSource()[[1]]
html1<- read_html(html) 

get_prices<-function(html){
  html %>%
    html_nodes(xpath='//*[@id="overview-models-carousel-all-2021"]/div/div/div/div/div/div/div[3]/p/span/span') %>% 
    html_text()%>% 
    str_trim()%>% 
    unlist() 
}

lp<-get_prices(html1)

names(ln)<-c(1:12)

get_name<-function(html){
  html %>%
    html_nodes(xpath='//*[@id="overview-models-carousel-all-2021"]/div/div/div/div/div/div/div[1]/h3/span[2]') %>%
    html_text()%>%
    str_trim()%>%
    unlist()
} 

ln<-get_name(html1)
ln

get_hp<-function(html){
  html %>%
    html_nodes(xpath='//*[@id="overview-models-carousel-all-2021"]/div/div/div/div/div/div/div[5]/ul/li[2]/span') %>%
    html_text()%>%
    str_trim()%>%
    unlist()
} 
lh<-get_hp(html1)

get_fuel_efficiency<-function(html){
  html %>%
    html_nodes(xpath='//*[@id="overview-models-carousel-all-2021"]/div/div/div/div/div/div/div[4]/ul/li/div[2]/span') %>%
    html_text()%>%
    str_trim()%>%
    unlist()
} 
lfuel<-get_fuel_efficiency(html1)


df=data.frame(nom=ln,prix=lp,puissance=lh,la_consommation_de_carburant=lfuel)
  library("writexl")
write_xlsx(df,"C:\\Users\\azza\\Desktop\\atelier3.xlsx")

