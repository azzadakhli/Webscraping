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
remDr$navigate("https://www.jeep.ca/fr/build-and-price")


Sys.sleep(5)  
morereviews <- remDr$findElement(using = 'xpath', '//*[@id="zones_body_blocks_vehicle-selector"]/div/div[2]/div/div/button[3]')
morereviews$clickElement()
  Sys.sleep(5)

webElem <- remDr$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))  

Sys.sleep(5)

html <- remDr$getPageSource()[[1]]
html1<- read_html(html) 

get_prices<-function(html){
  html %>%
    html_nodes(xpath='//*[@id="zones_body_blocks_vehicle-selector"]/div/div[3]/div[1]/div/div/div[2]/div[1]/div/div/div[2]/div/div/div/div[2]') %>% 
    html_text()%>% 
    str_trim()%>% 
    unlist() 
}

lp<-get_prices(html1)

names(ln)<-c(1:7)

get_name<-function(html){
  html %>%
    html_nodes(xpath='//*[@id="zones_body_blocks_vehicle-selector"]/div/div[3]/div[1]/div/div/div[2]/div[1]/p/a') %>%
    html_text()%>%
    str_trim()%>%
    unlist()
} 

ln<-get_name(html1)
ln<-ln[-4]
ln<-ln[-4]
lp<-lp[-4]
lp<-lp[-4]

df<-data.frame(noms=ln,prix=lp)
View(df)
library("writexl")
write_xlsx(df,"C:\\Users\\azza\\Desktop\\atelierjeep.xlsx")
