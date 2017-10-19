rm(list=ls())


#wczytujemy dane
data <- read.csv("/train.csv")

#zmieniamy format daty
data$date <- as.Date(data$Dates, format = "%Y-%m-%d")

#wyciagamy tylko rok 
data$year <- format(data$date, "%Y")

#tworzymy liste dokonanych przestepstw
crimes <- levels(data$Category)
crimes

#ui -> dashboard z wyborem przestepstwa, wykresem i suwakiem roku wykroczenia
ui <- dashboardPage(
  dashboardHeader(title = "Mapa przestêpstw SF"),
  dashboardSidebar(selectInput("choice", "Wybór przestêpstwa:", choices = as.character(crimes), selected = "ASSAULT")),
  dashboardBody(
    fluidRow(
      box(leafletOutput("plot1", height = 400), width = 30)
    ),
    fluidRow(
      box(
        title = "Time",
        sliderInput("year", label = "Wybierz rok:", min = 2003, max = 2015, value = c(2010,2010), width = 300
      )
    )
  )
)
)

#server - reaguje na zadane parametry, zczytuje mape z serwera i mapuje zadane punkty w okó³ lokalizacji okreslonej geocode'm 

server <- function(input, output) {
  
  output$plot1 <- renderLeaflet({
    location <- geocode("San Francisco, CA")
    
    m <- leaflet() %>%  addProviderTiles(providers$CartoDB.Positron) %>% 
      setView(location$lon, location$lat, zoom = 14)
    m
    
    category <- input$choice
    time <- input$year
    data2<- data[data$Category == category & data$year>= time[1] & data$year<=time[2],]
    
    m %>% addCircleMarkers(data2$X, data2$Y, opacity = 0.1, 
                           clusterOptions = markerClusterOptions(), 
                           popup = paste("<b>", data2$Descript ,"</b>", data2$Address,data2$date, sep = "<br/>"))
  })
}

shinyApp(ui, server)


