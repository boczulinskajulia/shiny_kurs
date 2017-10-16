# zainstalujcie prosze ponizsze biblioteki. w razie jakichœ niezgodnosci piszcie. 

#paczki do zainstalowania: 

install.packages("lubridate")
install.packages("BH")
install.packages("dplyr")
install.packages("shiny")
install.packages("shinydashboard")
install.packages("data.table")
install.packages("leaflet")
install.packages("tidyr")
install.packages("countrycode")
install.packages("stringr")
install.packages("shinyHeatmaply")
install.packages("magrittr")
install.packages("DT")
install.packages("ggmap")

#wczytywanie: 
library(lubridate)
library(BH)
library(dplyr)
library(shiny)
library(shinydashboard)
library(data.table)
library(leaflet)
library(tidyr)
library(countrycode)
library(stringr)
library(shinyHeatmaply)
library(magrittr)
library(DT)
library(ggmap)

#dane na szkolenie  
ships <- read.csv("https://raw.githubusercontent.com/Appsilon/crossfilter-demo/master/app/ships.csv")

data <- read.csv("(wasza sciezka dostepu)/train.csv")

terrorism <- read.csv("(wasza sciezka)/terrorism.csv", header = TRUE, stringsAsFactors = FALSE )

crime <- read.csv("NYC_crime.csv", header = TRUE, stringsAsFactors = FALSE)[,1:23]

taxi <- fread("(wasza sciezka)/tripData.csv") #fread jest pochodzi z bilbioteki read.table i laduje szybciej pliki csv, a przy tym dobiera sobie parametry

#leaflet z linkiem do mapy (NIC Z TYM NIE ROBIMY NA RAZIE ;))

location <- geocode("San Francisco, CA")
m <- leaflet() %>% addTiles(url = "http://services.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}")
m <- m %>% addTiles(url = "http://services.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Reference/MapServer/tile/{z}/{y}/{x}")
m <- m %>% setView(location$lon, location$lat, zoom = 15)
m
