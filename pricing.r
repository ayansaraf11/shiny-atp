pricing_info <- read.csv("MySQL_CleanData180509_002.csv",stringsAsFactors = F)
# mean(na.omit(as.numeric(pricing_info$PriceConvertedUSD[which(grepl("Lightspeed Plus",pricing_info$Model))])))

pricing.for.average <- function(company,model){
  filter.byoem <- filter(pricing_info,pricing_info$OEM==company)
  filter.byoem.bymodel <- filter(filter.byoem,filter.byoem$Model==model)
  average.price <- mean(na.omit(as.numeric(filter.byoem.bymodel$PriceConvertedUSD)))
  return(average.price)
}

# for(i in 1:nrow(machine_data)){
#   filter.byoem <- filter(pricing_info,pricing_info$OEM==machine_data$Company[i])
#   filter.byoem.bymodel <- filter(filter.byoem,filter.byoem$Model==machine_data$Model[i])
#   machine_data$Average_Price[i] <- round(mean(na.omit(as.numeric(pricing_info[which(pricing_info$Model=="Lightspeed 16"),"PriceConvertedUSD"]))))
# }
# write.csv(machine_data,"mockdata.csv",row.names = F)


pricing.for.retail  <- function(company,model){
  filter.byoem <- filter(pricing_info,pricing_info$OEM==company)
  filter.byoem.bymodel <- filter(filter.byoem,filter.byoem$Model==model)
  average.price <- mean(na.omit(as.numeric(filter.byoem.bymodel$PriceConvertedUSD)))
  retail.price <- average.price * 1.1
  return(retail.price)
}

pricing.for.buyback  <- function(company,model){
  filter.byoem <- filter(pricing_info,pricing_info$OEM==company)
  filter.byoem.bymodel <- filter(filter.byoem,filter.byoem$Model==model)
  average.price <- mean(na.omit(as.numeric(filter.byoem.bymodel$PriceConvertedUSD)))
  buyback <- average.price * 0.85
  return(buyback)
}

price.plot <- function(company,model){
  a <- list(
    autotick = TRUE,
    tick0 = 0
  )
  return(plot_ly(x = c(pricing.for.retail(company,model),pricing.for.average(company,model),
                   pricing.for.buyback(company,model)), y = c("Retail","Average","Buyback"), type = 'bar', orientation = 'h') %>%
           layout(title=paste0("Price range of ",model),xaxis=a,autosize = F, width = 600, height = 150))
}

# p <- plot_ly(x = c(pricing.for.retail("GE","Lightspeed Plus"),pricing.for.average("GE","Lightspeed Plus"),
#                    pricing.for.buyback("GE","Lightspeed Plus")), y = c("retail","average","buyback"), type = 'bar', orientation = 'h')
