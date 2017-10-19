install.packages("heatmaply")
install.packages("shiny")
install.packages("shinyHeatmaply")

library(heatmaply)
library(shiny)
library(shinyHeatmaply)


data(mtcars)
data(iris)
launch_heatmaply(mtcars)

launch_heatmaply( iris)
?launch_heatmaply


###########################
#polaczenie do teradaty 
install.packages("RODBC")
library(RODBC)

channel2 <- odbcConnect("pdwh",uid="uid",pwd="")

dane2<- sqlQuery(channel2,"select * from DM_FTTH_REPORTING.V2_FAC_ZASIEG sample 100000")