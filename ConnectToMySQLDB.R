library(RMySQL)
library(RODBC)
library(DBI)


# # R Code to run the Stored Procedure
# con = odbcConnect("localhost", uid="jraman", pwd = "jraman")
# users0 = sqlQuery(con, "CALL getusers0")
# 
# close(con)



#Connect to the database : 
mydb = dbConnect(MySQL(), user='jraman', password='jraman', 
                 dbname='vault_db', host='10.11.2.56')


#Execute the query
#dbSendQuery(mydb, 'drop table if exists some_table, some_other_table')

#Save the results of the executed query in a recordset
query <- 'SELECT * FROM assets_inventory'
rs <- dbSendQuery(mydb, query)


#I believe that the results of this query remain on the MySQL server, 
#to access the results in R we need to use the fetch function.
asset_data <- fetch(rs, n=-1)


# #Code to archive old RawData files : To be Added
# #Get all files in existing RawData
# list.of.files <- list.files("./RawData",full.names=T)
# #Move all CSV files to RawData Archive
# archive_folder <- "./RawData_Archive"
# file.copy(list.of.files, archive_folder)
# #Empty the RawData folder
# unlink(list.of.files, recursive=TRUE, force=FALSE)
# 
# #This saves the results of the query as a data  frame object. 
# #The n in the function specifies the number of records to retrieve, 
# #using n=-1 retrieves all pending records.
# 
# #Write the data frame to the raw CSV file
# filename <- paste0("./RawData/RawData_", format(Sys.time(), "%d-%b-%Y-%H.%M"), ".csv")
# write.csv(raw_data_from_db, filename)



#Clear Resultset
dbClearResult(rs)
#Disconnect from database
dbDisconnect(mydb)
