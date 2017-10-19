rm(list= ls())

terrorism <- read.csv("C:/Users/boczujul/Desktop/shiny/gtd/terrorism.csv", 
                      header = TRUE, stringsAsFactors = FALSE )

#szybsze niz read.csv i automatycznie dobiera separatory do zbioru 

terrorism2 <- fread("/terrorism.csv")
terrorism2<- na.omit(terrorism2)


# 80 tysiecy

#pomijamy braki danych 
terrorism2 <- na.omit(terrorism)

#tworzymy dashboard 
ui <- 
  dashboardPage(skin = "yellow",
                dashboardHeader(title = "Terroryzm w latach 1970 - 2015 ", 
                                titleWidth = 680 #naglowek 
                                ),
                dashboardSidebar(disable = TRUE), 
                #opuszczamy dashboardSidebar, ale element wciaz musi byæ zaimplikowany w strukturze, aby aplikacja dzialala
                dashboardBody( #cialo dashboardu 
                  fluidRow( #najpierw wiersz, a w ramach niego kolejne kolumny 
                    column(width = 9, #pierwsza kolumna - bêdzie to obiekt z 
                           # podpisem oraz wykresem, dlatego te¿ o szerokoœci 9 jednostek
                           box(width = NULL, 
                               leafletOutput("worlmap", height = 500))),
                    column(width = 3, #kolumna 2 - wszystkie filtry 
                           box(width = NULL, 
                               sliderInput("year",  #wybor roku - suwak
                                           "Filtrowanie po latach:",
                                           min = 1970,
                                           max = 2015,
                                           value =  2015), #ograniczamy do 
                               # jednego roku, aby mapa wyswietlala siê szybko na starcie 
                               selectInput("typeattack", label = "Typ ataku",  #wybor ataku - lista 
                                           choices = c("All", "Bombing/Explosion", 
                                                       "Armed Assault",
                                                       "Assassination",
                                                       "Unknown",
                                                       "Hostage Taking (Kidnapping)",
                                                       "Hostage Taking (Barricade Incident)",
                                                       "Facility/Infrastructure Attack",
                                                       "Hijacking", "Unarmed Assault"), selected = "All"),
                               selectInput("numdead", label = "Liczba zabitych osob", #wybor liczby zabitych osob (kategoryzacja potem) - lista 
                                           choices = c("All" = "All", 
                                                       "1" = "1",
                                                       "2 - 10"  = "2 and 10",
                                                       "11 - 100" = "11 and 100",
                                                       "101 - 500" = "101 and 500",
                                                       ">500" = "more 500"), selected = "All")
                               
                           )
                    )
                  )
                )
  )


server <- function(input, output) { 
  
  color<-colorFactor(topo.colors(9), terrorism$attacktype1_txt)
  

  #generujemy rozmiar punktu na mapie w zaleznosci od liczby zabitych osob 
  terrorism2$size <- ifelse(terrorism2$nkill == 1, 1,
                            ifelse(terrorism2$nkill > 1 & terrorism2$nkill <= 10, 2,
                                   ifelse(terrorism2$nkill > 10 & terrorism2$nkill <= 100, 3, 
                                          ifelse(terrorism2$nkill > 100 & terrorism2$nkill <= 500, 4, 5))))
  
  #generujemy tekst, ktory bedzie pokazywal siê po kliknieciu na punkt 
  terrorism2$popupyear <- paste(sep = ": ", "<b>Year</b>", terrorism2$iyear)
  terrorism2$popupcountry <- paste(sep = ": ", "<b>Country</b>", terrorism2$country_txt)
  terrorism2$popupcity <- paste(sep = ": ", "<b>City</b>", terrorism2$city)
  terrorism2$popupname <- paste(sep = ": ", "<b>Name of organization</b>", terrorism2$gname)
  terrorism2$popuptype <- paste(sep = ": ", "<b>Type of attack</b>", terrorism2$attacktype1_txt)
  terrorism2$popupnkill <- paste(sep = ": ", "<b>Number of people killed</b>", terrorism2$nkill)
  terrorism2$summary <- paste(sep = ": ", "<b>Summary</b>", terrorism2$summary)
  terrorism2$popup <- paste(sep = "<br/>", terrorism2$popupyear, terrorism2$popupcountry, terrorism2$popupcity,
                            terrorism2$popupname, terrorism2$popuptype, terrorism2$popupnkill, terrorism2$summary)
  
  
  #MAPA
  output$worlmap <- renderLeaflet({
    
    #filtry do zbioru - odwolujemy siê do tego, co zostalo zaimplikowane w input'cie (ui) 
    terrorism3 <- terrorism2 %>%
      filter(iyear == input$year) #filtr roku 
    
    if(input$typeattack != "All") {
      terrorism3 <- terrorism3[terrorism3$attacktype1_txt == input$typeattack,]} #aby mapa dzialala szybciej pomijamy mozliwosc wyswietlenia wszystkich 
                                                                                  #atakow, co uwzgledniamy w petli
    
    if(input$numdead == "All"){         #filtr liczby zabitych 
      terrorism3 <- terrorism3
    } else if(input$numdead == "1") {
      terrorism3 <- terrorism3[terrorism3$nkill == 1,]
    } else if(input$numdead == "2 and 10") {
      terrorism3 <- terrorism3[terrorism3$nkill > 1 & terrorism3$nkill <= 10,]
    } else if(input$numdead == "11 and 100") {
      terrorism3 <- terrorism3[terrorism3$nkill > 10 & terrorism3$nkill <= 100,]
    }  else if(input$numdead == "101 and 500") {
      terrorism3 <- terrorism3[terrorism3$nkill > 100 & terrorism3$nkill <= 500,]
    } else {
      terrorism3 <- terrorism3[terrorism3$nkill > 500,]
    }  
    
   
    
    if (nrow(terrorism3) != 0) { #jezeli filtry znajda zbior wspolny >0 jednego wiersza, to generujemy mapke z punktami
      
      leaflet(terrorism3) %>% 
        addProviderTiles(providers$CartoDB.Positron) %>%
        setView(lng = min, 19, zoom = 4) %>%
        addCircleMarkers(~terrorism3$longitude, ~terrorism3$latitude, color = color(terrorism3$attacktype1_txt), 
                         popup = ~terrorism3$popup, 
                         label = ~as.character(terrorism3$iyear), radius = (~terrorism3$size))
    } else {
      
      leaflet() %>%  #jezeli nie znajda takiego zbioru, to generuje siê pusta mapka
        addProviderTiles(providers$CartoDB.Positron) %>%
        setView(-5.273437, 19, zoom = 4)
      
    }
    
  })      
  
  
  
} 

shinyApp(ui = ui, server = server)
