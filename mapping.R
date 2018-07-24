library(zipcode)
library(tidyr)
library(plotly)
library(dplyr)
data(zipcode)

machine_data <- read.csv("mockdata.csv", stringsAsFactors = F)
zipcode %>% mutate(zip = readr::parse_number(zip))

zipcode$zip <- as.numeric(zipcode$zip)

new <- right_join(zipcode, machine_data, by = "zip")

tracking_asset <- function(filterName){
  g <- list(
    scope = 'usa',
    projection = list(type = 'albers usa'),
    showland = TRUE,
    landcolor = toRGB("gray95"),
    subunitcolor = toRGB("gray85"),
    countrycolor = toRGB("gray85"),
    countrywidth = 0.5,
    subunitwidth = 0.5
  )
  
  blah <- filter(new,new$Model==filterName)
  
  p <- plot_geo(blah, lat = ~latitude, lon = ~longitude) %>%
    layout(geo = g) %>%
    add_markers(
      text = ~paste(Company,paste(Type,"-",Model),City,State,sep = "<br />")
    )
  return(p)
}
