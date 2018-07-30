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

#Determine x axis limit for OEM barplot by finding the OEM with the max number of unique assets
oem_plot_data <- select(metaTable, UID, Company)
oem_plot_data <- unique(oem_plot_data)
oem_plot_data$Company <- as.character(oem_plot_data$Company)
oem_plot_data$Company_Sum <- as.numeric(ave(oem_plot_data$Company, oem_plot_data$Company, FUN = length))
x_axis <- max(oem_plot_data$Company_Sum)

#Create df with only unique companies and their total number of unique assets
oem_plot_data_2 <- oem_plot_data %>% group_by(Company) %>% summarise(top = max(Company_Sum)) %>%
  arrange(top)

#Format oem plot
test_a <- ggplot(data=oem_plot_data_2, aes(x=Company, y=top, fill = Company)) +
  geom_bar(stat="identity") +
  coord_flip() +
ggtitle("Asset Overview") +
  xlab("Company") +
  ylab("Total") +
  geom_text(aes(label=top, vjust= 2, hjust = 2)) +
  theme(title=element_text(size=16, face = "bold"), axis.text=element_text(size=12, face = "italic"),
        axis.title=element_text(size=14,face = "italic"))
  
  
  