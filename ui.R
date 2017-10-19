library(shiny)


#tworzymy strukture wizualizacji
ui <- dashboardPage(
  dashboardHeader(title = "Przestêpstwa w NYC"), #naglowek
  dashboardSidebar( 
    selectInput("Choice", "Wybierz kategoriê przestêpstwa:", 
                choices = as.character(crime$LawTerm), selected = "FELONY"), 
    sliderInput("Day", label = "wybierz zakres dni :", min = 1, max = 31, value = c(1,1)),
    sliderInput("Month", label = "wybierz zakres miesiêcy:", min=1, max = 12, value = c(12,12))
    ),
  dashboardBody( #cialo dashboardu
    fluidRow(
      box(leafletOutput("map", height = 700), width = 300)
    )
  )
)

