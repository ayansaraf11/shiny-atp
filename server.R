library(shiny)
library(dplyr)
library(shinyjs)
library(V8)
source("mapping.R")
shinyServer(function(input,output,session){
  colnames(machine_data) <- c("UID" ,"MD5 Hash Values","Year_Installed","City","State","zip","Purchase_Price","Number_of_services",
                              "Company","Type","Model","Coil_Thickness","Patient_Weight_Limit")
  value123 <- reactiveVal("Signa EXCITE 3.0T")
  output$machine_name <- renderUI({
    filter.name.bycompany <- filter(machine_data,Company==input$company)
    filter.name <- filter(filter.name.bycompany,Type==input$machine_type)
    selectInput("name","Name of Machine",choices= unique(filter.name$Name),selected = value123())
  })
  output$mytable <- renderDataTable(
    machine_data[,-2]
    # options = list(pageLength = 5),
    # callback = "function(table) {
    # table.on('click.dt', 'tr', function() {
    # $(this).toggleClass('selected');
    # Shiny.onInputChange('rows',
    # table.rows('.selected').indexes().toArray());
    # });}"
  )
  observeEvent(input$edit, {
    show("purchase_price")
    show("service")
    show("city")
    show("state")
    show("pwl")
    show("thickness")
    show("submit")
  })
  
  
  output$machineCount <- renderValueBox({
    valueBox(length(unique(machine_data$Model)), "Machines in the Inventory", icon = icon("list"), color = "blue")
  })
  
  output$totalValue <- renderValueBox({
    valueBox(paste0("$",sum(machine_data$Purchase_Price)),"Total Value of Listings",icon = icon("dollar"),color = "yellow")
  })
  
  output$averageValue <- renderValueBox({
    valueBox(paste0("$",floor(sum(machine_data$Purchase_Price)/length(machine_data$Model))),"Average Value of Listing",icon = icon("dollar"),color = "green")
  })
  
  output$oemplot <- renderPlot({
    barplot(table(machine_data$Company),horiz = TRUE, col = "skyblue",main = "Variety of OEMs in AMP")
  })
  
  output$track_asset_plot <- renderPlotly({
    tracking_asset(input$select_asset)
  })
  
  dataReactive <- reactive({
    data.frame(Company = c(input$company), Type = c(input$machine_type), Name = c(input$name), Purchase_Price = c(input$purchase_price),
               Number_of_services = c(input$service),City = c(input$city),State = c(input$state),Patient_Weight_Limit = c(input$pwl),
               Coil_Thickness = c(input$thickness))
  })
  observeEvent(input$submit, {
    metaTable <- rbind(machine_data,dataReactive())
    write.csv(metaTable,"mockdata.csv",row.names = F,na = "")
    js$reset()
  })
})