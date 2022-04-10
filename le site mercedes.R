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
remDr$navigate("https://www.mercedes-benz.ca/en/home")


Sys.sleep(5)  

webElem <- remDr$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))  

Sys.sleep(5)

pas3<-function(i){
  paste('//*[@id="js-modal-page"]/div[1]/header/nav/ul/li[1]/div/div/div[3]/ul/li[1]/ul/li[',i,']/div/a')
}

get_horsepower<-function(html){
  html %>%
    html_nodes(xpath='//*[@id="visualizer"]/div/div/div[5]/div/ul/li[2]/p/span[3]/span[1]')%>% 
    html_text()%>% 
    str_trim()%>% 
    unlist() 
} 
l<-c()

for(i in 1:9){
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
  l<-c(l,get_horsepower(html1))
}

hp<-function(ch){
  paste(ch,"hp ")
}

l<-sapply(l,hp)

get_acc<-function(html){
  html %>%
    html_nodes(xpath='//*[@id="visualizer"]/div/div/div[5]/div/ul/li[1]/p/span[3]/span[1]')%>% 
    html_text()%>% 
    str_trim()%>% 
    unlist() 
}

l3<-c()
for(i in 1:9){
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
  l3<-c(l3,get_acc(html1))
}
se<-function(ch){
  paste(ch,"sec ")
}
l3<-sapply(l3,se)
l3[5]<-""

get_prices<-function(html){
  html %>%
    html_nodes(xpath='//*[@id="js-modal-page"]/div[1]/header/nav/ul/li[1]/div/div/div[3]/ul/li[1]/ul/li/div/a/p[2]/span[2]') %>% 
    html_text()%>% 
    str_trim()%>% 
    unlist() 
} 


l1<-get_prices(html1)

install.packages("stringi") 
library(stringi) 

remove<-function(l1){
  stri_replace_all_regex(l1, "[\n Disclaimer]", "") 
}
pas<-function(ch){
  paste("starting at",ch,sep = " ")
} 
l1<-remove(l1)
l1<-sapply(l1, pas)

names(l1)<-c(1:9) 
get_name<-function(html){
  html %>%
    html_nodes(xpath='//*[@id="js-modal-page"]/div[1]/header/nav/ul/li[1]/div/div/div[3]/ul/li[1]/ul/li/div/a/p[1]') %>%
    html_text()%>%
    str_trim()%>%
    unlist()
} 
l2<-get_name(html1)
l2

df<-data.frame(noms=l2,prix=l1,puissance=l,accélération=l3) 
df

View(df)

library("writexl")
write_xlsx(df,"C:\\Users\\azza\\Desktop\\atelier1.xlsx")




