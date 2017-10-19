
rm(server)

#ustawiamy srodowisko
setwd("/shiny") 
dir.create("leaflet")
setwd("leaflet")

#tworzymy pliki 

file.create("server.R")
file.create("ui.R")

#przechodzimy do nich 
file.edit("server.R")

file.edit("ui.R")


crime <- read.csv("NYC_crime.csv", header = TRUE, stringsAsFactors = FALSE)[,1:23]

#uporzadkujemy zbiorek 
#usuwamy braki danych (wizualizacja ich nie wezmie, a bêdzie je niepotrzebnie ladowac do srodowiska i spowalniac dzialanie aplikacji )
crime <- na.omit(crime)
crime$Crime <-crime$OFNS_DESC
crime$Date<- crime$CMPLNT_FR_DT 
crime$District <- crime$BORO_NM
crime$LawTerm <- crime$LAW_CAT_CD

#wybieramy zmienne do wizualizacji
crime<-crime[,c(22:27)]

#rozlaczamy date na pojedyncze skladowe 
crime <-
  crime %>%
  separate(col = Date, into = c("Month", "Day", "year"), sep = "/", 
           remove = FALSE, extra = "drop")

write.csv(crime, file = "/crime_new.csv", row.names = FALSE) #zapisany plik 


#odpalamy aplikacje
shinyApp(ui = ui, server = server)

