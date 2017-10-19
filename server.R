server<- function(input, output) {
  
  color<-colorFactor(topo.colors(7), crime$Crime) #nadajemy kropkom kolory analogicznie do przestepstw  
  
  output$map <- renderLeaflet({
  
  #tworzymy mapke  
   m <- leaflet(crime) %>% 
      setView(lng =-73.98928, lat = 40.75042, zoom = 12) %>% 
      addProviderTiles("CartoDB.Positron", options = providerTileOptions(nowrap = TRUE)) 
   m
   
   #parametryzujemy odwolujac sie do fitrow
   
   
   cat <- input$Choice
   day <- input$Day 
   month <- input$Month
   crime2 <- crime[crime$LawTerm==cat & crime$Day >= day[1] & crime$Day <= day[2] 
                   & crime$Month >= month[1] & crime$Month<=month[2],]
     
     
    #nakladamy punkty 
    m %>%  addCircleMarkers( 
        lng =~ crime2$Longitude,
        lat =~ crime2$Latitude, 
        stroke = FALSE, 
        fillOpacity = 0.5, 
        color =~ color(crime2$Crime),
        clusterOptions = markerClusterOptions(),
        popup =~paste( #dodajemy tekst widoczny po kliknieciu 
          
          "<b>", as.character(crime2$Crime), "</b></br/>", 
          "date:", as.character(crime2$Date), "</br>",
          "law category:", crime2$LawTerm
        
        )
         )
     
  })
}

