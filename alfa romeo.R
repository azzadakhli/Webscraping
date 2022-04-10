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
remDr$navigate("https://www.alfaromeo.ca/en/stelvio")
Sys.sleep(5)  

webElem <- remDr$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))  

Sys.sleep(5)
html <- remDr$getPageSource()[[1]] 
html1<- read_html(html)

get_informations<-function(html,ch){
  html %>%
    html_nodes(xpath=ch) %>% 
    html_text()%>% 
    str_trim()%>% 
    unlist() 
}
l1<-get_informations(html1,'//*[@id="slick-slide50"]')
l2<-get_informations(html1,'//*[@id="slick-slide51"]')
l3<-get_informations(html1,'//*[@id="slick-slide52"]')
l4<-get_informations(html1,'//*[@id="slick-slide53"]')
install.packages("stringi") 
library(stringi) 

tremove<-function(l1,ch){
  stri_replace_all_regex(l1,ch , "") 
}
app<-function(l1){
  l1<-tremove(l1,"\t")
  l1<-tremove(l1,"\n")
  l1<-tremove(l1,'BUILD MY OWN')
  
}
l1<-app(l1)
l2<-app(l2)
l3<-app(l3)
l4<-app(l4)

tsplit<-function(l){
  str_split_fixed(l, "Starting at???",2)
}

l1<-tsplit(l1)
l2<-tsplit(l2)
l3<-tsplit(l3)
l4<-tsplit(l4)

df<-data.frame(noms=c(l1[1],l2[1],l3[1],l4[1]),prix=c(l1[2],l2[2],l3[2],l4[2]))
library("writexl")
write_xlsx(df,"C:\\Users\\azza\\Desktop\\atelieromeo.xlsx")


