pricing_info <- read.csv("MySQL_CleanData180509_002.csv",stringsAsFactors = F)
# mean(na.omit(as.numeric(pricing_info$PriceConvertedUSD[which(grepl("Lightspeed Plus",pricing_info$Model))])))

pricing <- function(company,model){
  filter.byoem <- filter(pricing_info,pricing_info$OEM==company)
  filter.byoem.bymodel <- filter(filter.byoem,filter.byoem$Model==model)
  return(mean(na.omit(as.numeric(filter.byoem.bymodel$PriceConvertedUSD))))
}
