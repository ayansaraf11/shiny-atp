jsResetCode <- "shinyjs.reset = function() {history.go(0)}"
dashboardPage(skin = "blue",
  dashboardHeader(title = "iDX"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("dashboard")),
      menuItem("Add/Edit Assets", tabName = "add", icon = icon("inventory"),
               menuSubItem("Add New Asset", tabName = "add_asset", icon = icon("plus")),
               menuSubItem("Edit Exisiting Asset", tabName = "edit_asset", icon = icon("edit"))),
      menuItem("View Assets", tabName = "view",icon = icon("search")),
      menuItem("Track Assets",tabName= "track",icon = icon("globe"))
    )
  ),
  dashboardBody(
    
    tabItems(
      tabItem(tabName="home",fluidRow(
              valueBoxOutput("machineCount"),
              valueBoxOutput("totalValue"),
              valueBoxOutput("averageValue")),
              fluidRow(column(2, selectInput("selected", "Filter Asset Inventory",
                    choices = list("Brand" = "Brand", "Type" = "Type"), selected = "OEM")),
                    column(width = 2, offset =4, selectInput("Pick", "Filter Asset Map",
                                choices = list("All" = "All", "GE" = "GE", "Philips" = "Philips",
                                               "Siemens" = "Siemens", "Toshiba" = "Toshiba"),
                                selected = "All"))),
              fluidRow(
                box(status = "primary", width = 6, plotOutput("oemplot")),
                box(status = "success", width = 6, plotlyOutput("allAsset"))
              )),
      tabItem(tabName = "edit_asset"),
    tabItem(tabName = "add_asset",
            sidebarPanel(
              selectInput("company","Choose OEM",
                          choices = unique(machine_data$OEM),
                          selected = value2),
              selectInput("machine_type","Type of Machine",
                          choices= unique(machine_data$Category),
                          selected = unique(machine_data$Category)[1]),
              uiOutput("machine_name"),
              dateInput("year","Date of Purchase",format = "yyyy-mm-dd"),
              useShinyjs(),
              actionButton("edit","Edit Features")
            ),
            mainPanel(
              uiOutput("ui"),
              useShinyjs(),
              fluidRow(
                column(6,
              hidden(textInput("purchase_price","Purchase Price",value = machine_data[which(machine_data$Model==value1),"Purchase_Price"]))),
                column(6,
              hidden(textInput("service","Service record",value = machine_data[which(machine_data$Model==value1),"Number_of_services"])))),
              fluidRow(
                column(6,
              hidden(textInput("city","Location City",value = machine_data[which(machine_data$Model==value1),"City"][length(machine_data[which(machine_data$Model==value1),"City"])]))),
                column(6,
              hidden(selectInput("state","Location State",choices = state.name,selected = state.name[which(state.name==machine_data[which(machine_data$Model==value1),"State"][length(machine_data[which(machine_data$Model==value1),"State"])])])))),
              fluidRow(
                column(6,
              hidden(textInput("pwl","Patient Weight Limit (lbs)",value = machine_data[which(machine_data$Model==value1),"Patient_Weight_Limit"]))),
                column(6,
              hidden(textInput("thickness","Coil Thickness (mm)",value = machine_data[which(machine_data$Model==value1),"Coil_Thickness"])))),
              extendShinyjs(text = jsResetCode),
              hidden(actionButton("price","Price Analysis")),
             hidden(actionButton("submit","Add to Inventory")),
             br(),
              dataTableOutput("priceTable"),
             br(),
             plotlyOutput("price_plot")
              )),
    tabItem("view",
            fluidRow(box(status = "primary", width = 6,
            dataTableOutput("mytable")),
              box(status = "primary", width = 4,
              h4(htmlOutput("select_text_1")),
              h4(htmlOutput("select_text_2")),
              h4(htmlOutput("type.asset")),
              h4(htmlOutput("select_text")),
              br(),
              h4(htmlOutput("year_mfg")),
              h4(htmlOutput("location_text")),
              br(),
              h4(htmlOutput("p.price")),
              h4(htmlOutput("r.price")),
              h4(htmlOutput("s.price")),
              h4(htmlOutput("b.price"))),
            column(6,plotOutput("avg_plot", height = "125px", width = "370px"))
            )
            ),
    tabItem("track",
            sidebarPanel(
              selectInput("select_asset","Choose Asset to Track",
                          choices = unique(machine_data$Model),
                          selected = unique(machine_data$Model[1]))
            ),
              mainPanel(
                box(title = "Asset Map", width = 12 ,status = "primary", height = "auto",
                    solidHeader = T,plotlyOutput("track_asset_plot")),
             box(title = "Asset History", width = 12 ,status = "primary", height = "auto",
                 solidHeader = T, dataTableOutput("track_asset_table"))))
  )
))


