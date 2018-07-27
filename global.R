require(shiny)||install.packages("shiny")
require(dplyr)||install.packages("dplyr")
require(shinyjs)||install.packages("shinyjs")
require(V8)||install.packages("V8")
require(shinydashboard)||install.packages("shinydashboard")
require(shinythemes)||install.packages("shinythemes")
require(DT)||install.packages("DT")
require(plotly)||install.packages("plotly")
require(zipcode)||install.packages("zipcode")
require(tidyr)||install.packages("tidyr")
require(digest)||install.packages("digest")

value1 <- "Lightspeed 16"
value2 <- "GE"
machine_data <- read.csv("mockdata.csv",stringsAsFactors = F)
metaTable <- machine_data
options(warn = -1)