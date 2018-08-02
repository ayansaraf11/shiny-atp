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
machine_data <- read.csv("mockdata.csv",stringsAsFactors = F, row.names = NULL)
metaTable <- machine_data
metaTable$row.names <- NULL
options(warn = -1)

source("mapping.R")
source("pricing_info.R")
source("dashboard.R")
