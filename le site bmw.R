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
remDr$navigate("https://www.bmw.ca/en/home.html")


Sys.sleep(5)  

webElem <- remDr$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))  

Sys.sleep(5)

morereviews <- remDr$findElement(using = 'xpath', "/html/body/div[2]/div[2]/div/div/div[2]/div/div[2]/div/div/div[2]/div/div/div/div[1]/div[1]/div[1]/nav/div/ul/li[8]/button")
morereviews$clickElement()

Sys.sleep(5)

webElem <- remDr$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))  

Sys.sleep(5)
html <- remDr$getPageSource()[[1]] 
html1<- read_html(html) 

pas<-function(i){
  paste("/html/body/div[2]/main/div[1]/div[6]/div[2]/div[",i,"]/div/div[2]/span",sep="")
}

get_prices_gammeX<-function(html,i){
  html %>%
    html_nodes(xpath=pas(i))%>% 
    html_text()%>% 
    str_trim()%>% 
    unlist() 
} 
l<-c()
for (i in 19:29) {
  l<-c(l,get_prices(html1,i))
}
l

names(l)<-c(1:9) 

pas1<-function(i){
  paste("/html/body/div[2]/main/div[1]/div[6]/div[2]/div[",i,"]/div/div[2]/a/span")
}

get_name<-function(html,i){
  html %>%
    html_nodes(xpath=pas1(i)) %>%
    html_text()%>%
    str_trim()%>%
    unlist()
}
l1<-c()
for (i in 19:29) {
  l1<-c(l1,get_name(html1,i))
}
l1

pas3<-function(i){
  paste('/html/body/div[2]/div[2]/div/div/div[2]/div/div[2]/div/div/div[2]/div/div/div/div[1]/div[2]/div[',i,']/div/div[2]/span')
}

get_horsepower1<-function(html){
  html %>%
    html_nodes(xpath='//*[@id="conConfigure"]//con-configure-mobile//div/con-stream-section[1]/div/div/con-engine-selector//div[1]/con-engine-details//con-table-bmw//div/div[2]/div[2]/span[2]')%>% 
    html_text()%>% 
    str_trim()%>% 
    unlist() 
} 
n<-c()
for(i in 19:29){ 
  morereviews <- remDr$findElement(using ='xpath', '/html/body/div[2]/div[2]/div/div/div[2]/div/div[2]/div/div/div[2]/div/div/div/div[1]/div[1]/div[1]/nav/div/ul/li[8]/button')
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
  n<-c(n,get_horsepower1(html1))
}

df1<-data.frame(noms=l1,prix=l) 
df1

View(df1)

library("writexl")
write_xlsx(df1,"C:\\Users\\azza\\Desktop\\atelier.xlsx")