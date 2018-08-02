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

#Determine x axis limit for OEM barplot by finding the OEM with the max number of unique assets
oem_plot_data <- select(metaTable, UID, Company, Type)
oem_plot_data <- unique(oem_plot_data)
oem_plot_data$Company <- as.character(oem_plot_data$Company)
oem_plot_data$Company_Sum <- as.numeric(ave(oem_plot_data$Company, oem_plot_data$Company, FUN = length))
oem_plot_data$Type <- as.character(oem_plot_data$Type)
oem_plot_data$Type_Sum <- as.numeric(ave(oem_plot_data$Type, oem_plot_data$Type, FUN = length))
x_axis <- max(oem_plot_data$Company_Sum)
x_axis_2 <- max(oem_plot_data$Type_Sum)

#Create 2 df with only unique companies or unique models (both with totals)
oem_plot_data_company <- oem_plot_data %>% group_by(Company) %>% summarise(top = max(Company_Sum)) %>%
  arrange(top)
oem_plot_data_type <- oem_plot_data %>% group_by(Type) %>% summarise(top_2 = max(Type_Sum)) %>%
  arrange(top_2)

#Format Company Plot
plot_company <- ggplot(data=oem_plot_data_company, aes(x=oem_plot_data_company$Company,
                                                       y=top)) +
  geom_bar(stat="identity", fill="dodgerblue2", colour="black") +
  coord_flip() +
 ggtitle("Asset Overview") +
  xlab("Brand") +
  guides(fill=F) +
  ylab("Total") +
  geom_text(aes(label=top, vjust= 2, hjust = 2)) +
  theme(title = element_text(hjust = 0.5, size=16, face = "bold"), axis.text=element_text(size=12, face = "italic"),
        axis.title=element_text(size=14,face = "italic"))
 #Format Type Plot 
plot_type <- ggplot(data=oem_plot_data_type, aes(x=oem_plot_data_type$Type, y=top_2)) +
  geom_bar(stat="identity", fill="dodgerblue2", colour="black") +
  coord_flip() +
  ggtitle("Asset Overview") +
  xlab("Type") +
  guides(fill=F) +
  ylab("Total") +
  geom_text(aes(label=top_2, vjust= 1, hjust = 2)) +
  theme(title=element_text(hjust = 0.5, size=16, face = "bold"), axis.text=element_text(size=12, face = "italic"),
        axis.title=element_text(size=14,face = "italic"))
  