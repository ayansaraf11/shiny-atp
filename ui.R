library(shinydashboard)
library(shinythemes)
library(DT)
library(plotly)
library(shinyjs)

jsResetCode <- "shinyjs.reset = function() {history.go(0)}"
dashboardPage(skin = "blue",
  dashboardHeader(title = "iDX ATP"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("dashboard")),
      menuItem("Add Listing", tabName = "add", icon = icon("plus")),
      menuItem("View Inventory", tabName = "view",icon = icon("search")),
      menuItem("Track Assets",tabName= "track",icon = icon("globe"))
    )
  ),
  dashboardBody(
    
    tabItems(
      tabItem(tabName="home",fluidRow(
              valueBoxOutput("machineCount"),
              valueBoxOutput("totalValue"),
              valueBoxOutput("averageValue")),
              fluidRow(
                box(plotOutput("oemplot"))
              )),
    tabItem(tabName = "add",
            sidebarPanel(
              selectInput("company","Choose OEM",
                          choices = unique(machine_data$Company),
                          selected = unique(machine_data$Company)[1]),
              selectInput("machine_type","Type of Machine",
                          choices= unique(machine_data$Type),
                          selected = unique(machine_data$Type)[1]),
              uiOutput("machine_name"),
              dateInput("year","Date of Purchase",format = "yyyy-mm-dd"),
              useShinyjs(),
              actionButton("edit","Edit Features")
            ),
            mainPanel(
              uiOutput("ui"),
              useShinyjs(),
              hidden(textInput("purchase_price","Purchase Price",value = machine_data[which(machine_data$Name==value1),"Purchase_Price"])),
              hidden(textInput("service","Service record",value = machine_data[which(machine_data$Name==value1),"Number_of_services"])),
              hidden(textInput("city","Location City",value = machine_data[which(machine_data$Name==value1),"City"])),
              hidden(selectInput("state","Location State",choices = state.name,selected = state.name[which(state.name==machine_data[which(machine_data$Name==value1),"State"])])),
              hidden(textInput("pwl","Patient Weight Limit (lbs)",value = machine_data[which(machine_data$Name==value1),"Patient_Weight_Limit"])),
              hidden(textInput("thickness","Coil Thickness (mm)",value = machine_data[which(machine_data$Name==value1),"Coil_Thickness"])),
             # extendShinyjs(text = jsResetCode),
              hidden(actionButton("submit","Add to Inventory"))
              )),
    tabItem("view",
            dataTableOutput("mytable")),
    tabItem("track",
              sidebarPanel(
              selectInput("select_asset","Choose Machine to Track",
                          choices = unique(machine_data$Model),
                           selected = unique(machine_data$Model[1]))),
              mainPanel(
             plotlyOutput("track_asset_plot"),
             box(title = "Asset History", width = "auto",status = "primary", height = "auto",solidHeader = T,scrollX = T, dataTableOutput("track_asset_table"))))
  )
))


