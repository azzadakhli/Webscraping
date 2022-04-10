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
remDr$navigate("https://www.audi.ca/ca/web/en/models.html?bytype=suv")
Sys.sleep(5)  

webElem <- remDr$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))  

Sys.sleep(5)
html <- remDr$getPageSource()[[1]]
html1<- read_html(html) 

get_prices<-function(html){
  html %>%
    html_nodes(xpath='//*[@id="nm-id-content"]/div[2]/audi-modelfinder/div/div/audi-modelfinder-car-model/div[1]/p') %>% 
    html_text()%>% 
    str_trim()%>% 
    unlist() 
}

lp<-get_prices(html1)

names(ln)<-c(1:9)

get_name<-function(html){
  html %>%
    html_nodes(xpath='//*[@id="nm-id-content"]/div[2]/audi-modelfinder/div/div/audi-modelfinder-car-model/div[1]/h2/span') %>%
    html_text()%>%
    str_trim()%>%
    unlist()
} 
ln<-get_name(html1)
ln
pas3<-function(i){
  paste('//*[@id="nm-id-content"]/div[2]/audi-modelfinder/div/div/audi-modelfinder-car-model['i']/div[3]/a')
}

get_hp1<-function(html){
  html %>%
    html_nodes(xpath='/html/body/div[1]/div[2]/div/div[6]/div[2]/div/audi-numbers/div/div[2]/div[1]/div/div')%>% 
    html_text()%>% 
    str_trim()%>% 
    unlist() 
} 
lhp<-c()
for(i in 1:12){
  morereviews <- remDr$findElement(using = 'xpath', '//*[@id="js-modal-page"]/div[1]/header/nav/div/ul[1]/li[1]/button')
  morereviews$clickElement()
  Sys.sleep(5)
  morereviews <- remDr$findElement(using = 'xpath', pas3(i))
  morereviews$clickElement()
  Sys.sleep(5)
  webElem <- remDr$findElement("css", "body")
  webElem$sendKeysToElement(list(key = "end")) 
  Sys.sleep(5)
  html <- remDr$getPageSource()[[1]] 
  html1<- read_html(html) 
  lhp<-c(l,get_horsepower(html1))
}

df=data.frame(names=ln,prices=lp) 

library("writexl")
write_xlsx(df,"C:\\Users\\azza\\Desktop\\atelieraudi.xlsx")
