
update.packages(ask = FALSE, checkBuilt = TRUE) 
#aktualiacja wszystkich zainstalowanych paczek

#pipe 
%>%  - # ctrl + shift + m 
#przetwarzanie strumieniowe 
  
#ui z przyciskiem do losowania punktow, dla ktorych sposob
# wyboru zostanie zadany w serverze

ui <- fluidPage(
  leafletOutput("mymap"),
  p(),
  actionButton("los", label = "New points")
)


server <- function(input, output, session) {
  
  points <- eventReactive(input$los, {
    cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite
      ) %>%
      addMarkers(data = points())
  })
}

shinyApp(ui, server)


##############/ 

#zadamy sobie wspolrzedne geograficzne punktu, ktory chcemy zobaczyc na mapie 

ui <- fluidPage(
  leafletOutput("mymap"),
  p(),
  h1("Wpisujemy punkcik"),
  p(),
  numericInput("long", label = h3("D³ugoœæ geograficzna:"), value = 11.242828),
  numericInput("lat", label = h3("Szerokoœæ geograficzna:"), value = 30.51470),
  actionButton("wpis", "Poka¿ punkt")
  
)

server <- function(input, output, session) {
  
  points <- eventReactive(input$wpis, {
    cbind(input$long, input$lat)
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      setView(lat = 30, lng = 11, zoom = 4) %>%
      addProviderTiles("Stamen.TonerLite") %>%
      addMarkers(data = points())
  })
}

shinyApp(ui, server)



