
shinyServer(function(input,output,session){
  machine_data <- read.csv("mockdata.csv",stringsAsFactors = F, row.names = NULL)
  metaTable <- machine_data
  metaTable$row.names <- NULL
  colnames(machine_data) <- c("UID","Year_Installed","City","State","zip","Purchase_Price","Number_of_services","Model",
                              "Type","Company","Coil_Thickness","Patient_Weight_Limit","MD5.Hash","Retail_Price")
  
  output$machine_name <- renderUI({
    filter.name.bycompany <- filter(metaTable,Company==input$company)
    filter.name <- filter(filter.name.bycompany,Type==input$machine_type)
    selectInput("name","Name of Machine",choices= unique(filter.name$Model),selected = value1)
  })
  
  output$mytable <- renderDataTable(
    showTable <- select(metaTable,Company,Type,Model), rownames = F)
    # pageLength = 5),
    # callback = "function(table) {
    # table.on('click.dt', 'tr', function() {
    # $(this).toggleClass('selected');
    # Shiny.onInputChange('rows',
    # table.rows('.selected').indexes().toArray());
    # });}"
  
  output$info_table <- renderDataTable({
    s = input$mytable_rows_selected
    car_fax <- unique(machine_data[s,c("UID")])
    machine_data[machine_data$UID %in% car_fax, ]})

  
  observeEvent(input$edit, {
    show("purchase_price")
    show("service")
    show("city")
    show("state")
    show("pwl")
    show("thickness")
    show("submit")
    show("price")
  })
  
  
  output$machineCount <- renderValueBox({
    valueBox(max(as.numeric(gsub("Asset","",machine_data$UID,ignore.case=T))), "Total Assets", icon = icon("list"), color = "blue")
  })
  output$totalValue <- renderValueBox({
    valueBox(paste0("$",format(sum(metaTable$Retail_Price, na.rm=TRUE), big.mark = ",")),"Total Value of Assets",icon = icon("dollar"),color = "yellow")
  })
  
  output$averageValue <- renderValueBox({
    valueBox(paste0("$",format(floor(sum(metaTable$Retail_Price, na.rm=TRUE)/length(metaTable$Model)), big.mark = ",")),"Average Value of Assets",icon = icon("dollar"),color = "green")
  })
  
  output$oemplot <- renderPlot({
    if(input$selected == "Brand"){
      plot_company           
    }                                        
    else if(input$selected == "Type"){
      plot_type
    }
  })
  
  output$track_asset_plot <- renderPlotly({
    tracking_asset(input$select_asset)
  })
  
  output$allAsset <- renderPlotly({
    allMachines(input$Pick)
  })
  output$track_asset_table <- renderDataTable({
    asset_history_table <- filter(metaTable,metaTable$Model==input$select_asset) %>% select(UID,Company,Type,Model,Retail_Price)
    datatable(asset_history_table,options = list(dom = 't'))
  })
  
  dataReactive <- reactive({
    data.frame(UID = c(paste0("Asset",length(unique(metaTable$UID))+1)),Year_Installed = c(2018) ,City = c(input$city),State = c(input$state),zip = c(91105),Purchase_Price = c(input$purchase_price),
               Number_of_services = c(input$service),Model = c(input$name),Type = c(input$machine_type),
               Company = c(input$company),Coil_Thickness = c(input$thickness),Patient_Weight_Limit = c(input$pwl),
               MD5.Hash = c(digest(paste0("Asset",length(unique(metaTable$UID))+1),algo = "md5",serialize = F)),
               Retail_Price = c(round(mean(na.omit(as.numeric(pricing_info[which(pricing_info$Model==input$name),"PriceConvertedUSD"]))))))
  })
  observeEvent(input$price, {
    tableReactive()
    plotReactive()
  })
  
  observeEvent(input$submit,{
    addRow <- rbind(metaTable,dataReactive())
    write.csv(addRow,"mockdata.csv",row.names = F,na = "")
    js$reset()
  })
  
  plotReactive <- reactive({
    output$price_plot <- renderPlotly(price.plot(input$company,input$name))
  })
  
  tableReactive <- reactive({
    output$priceTable <- renderDataTable({
      Standard = c("Retail Price","Sell Price","Buyback Price")
      Value = c(paste("$",format(round(pricing.for.retail(input$company,input$name)), big.mark = ",")),paste("$",format(round(pricing.for.sell(input$company,input$name)), big.mark = ",")),
                paste("$",format(round(pricing.for.buyback(input$company,input$name)), big.mark = ",")))
      df1 = data.frame(Standard,Value)
      colnames(df1) <- c("Price Standard", "Dollar Value")
      datatable(df1,options = list(dom = 't'))
    })
  })
})