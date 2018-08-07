library(rvest); library(tidyverse); library(future)

baseurl <- "https://www.nobroker.in/property/sale/mumbai/Mumbai/?nbPlace=ChIJwe1EZjDG5zsRaYxkjY_tpF0&price=0,100000000000000&lat_lng=19.1232561569964,72.8771623837987&latitude=19.1232561569964&longitude=72.8771623837987&orderBy=nbRank,desc&radius=2&propertyType=sale&pageNo="
# 
# nobrokercall <- function(url){
#   
#   doc <- read_html(url)
#   
#   #Area  
#   table1 <- doc %>% 
#     html_nodes("h2") %>% 
#     html_text() %>%
#     str_trim() %>% 
#     as.tibble() %>% 
#     slice(4:13) %>% 
#     as.tibble() %>% 
#     separate(value, c("BHK", "rest"), sep = " For Sale in ") %>% 
#     separate(rest, c("IN", "Area"), sep = "([,]*), ", extra = "merge")
#   
#   #Buitlup, EMI and Amount
#   table2 <- doc %>% 
#     html_nodes(".overview") %>% 
#     html_text() %>% 
#     str_trim() %>% 
#     str_replace_all("\n", "") %>% 
#     as.tibble() %>% 
#     slice(1:10) %>% 
#     separate(value, c("Builtup", "rest"), sep = "Builtup ") %>% 
#     separate(rest, c("EMI", "rest"), sep = "/MonthEstimated EMI ") %>% 
#     separate(rest, c("Amount", "Negotiable"), sep = "N") %>% 
#     mutate(Negotiable = ifelse(.$Negotiable == "egotiable", "Yes", "No"))
#   
#   # Landmark
#   table3 <- doc %>% 
#     html_nodes(".card-header-title h5") %>% 
#     html_text() %>% 
#     str_trim() %>% 
#     as.tibble()
#   
#   # more details
#   table4 <- doc %>% 
#     html_nodes(".semi-bold") %>% 
#     html_text() %>% 
#     str_trim() %>% 
#     matrix(nrow = 10, ncol = 4, byrow = TRUE) %>% 
#     as.tibble() %>% 
#     set_names(c("Faceing", "House Age", "No of Bathrooms", "Parking"))
#   
#   table5 <- doc %>% 
#     html_nodes(".card") %>% 
#     html_attr("id") %>% 
#     as.tibble()
#   
#   final_table <- reduce(c(table1, table2, table3, table4, table5), cbind) %>% as.tibble() %>% 
#     set_names("BHK", "IN", "Area", "Builtup", "EMI", "Amount", "Negotiable", "Landmark", "Faceing", "House Age", "NoofBathrooms", "Parking", "nobrokerID")
#   
#   Sys.sleep(10)
#   return(final_table)
#   #print("done")
#   
# }
# 
# all10 <- paste0(baseurl, 1:10) %>% map_df(nobrokercall)
# 
# #Verification
# all10 %>% filter(nobrokerID == "prop-ff8081815ec3ae62015ec7d29d454a44")
# "https://www.nobroker.in/property/buy/proportyidhere/detail"

#Individual web extract #Authentic

# first loop here and get id of 1000 houses
NB_get_ID_dump <- function(url, pageno) {
  
  #doc <- read_html(url)
  
  #Sys.sleep(sample(5:50, 1))
  
  getNBID <- read_html(url) %>% 
    html_nodes(".card") %>% 
    html_attr("id") %>% 
    as.tibble() %>% 
    separate(value, c("del", "id"), sep = "-") %>% 
    select(id) %>% 
    mutate(pageno = str_extract(url, "pageNo=.*")) %>% 
    write_csv(path = "nobrokerid.csv", append = TRUE)
  
}

#1:10 indicates 10 page
all_ids <- paste0(baseurl, 1:690) %>% map_df(possibly(NB_get_ID_dump, "notcaptured"))

# Loop here to get details of those 1000 houses

NB_ind_dump <- function(propid) {
  
  #https://www.nobroker.in/property/buy/ff80818164a2a27f0164a2b2a09c0b7d/detail
  #possibly(read_html, 'empty page')("https://www.nobroker.in/property/buy/detail")
  
  #ind_doc <- read_html(paste0("https://www.nobroker.in/property/buy/", propid ,"/detail"))
  
  ind_doc <- possibly(read_html, 'empty page')(paste0("https://www.nobroker.in/property/buy/", propid ,"/detail"))
  
  if(ind_doc != "empty page") {
    
  #Sys.sleep(sample(5:50, 1)) #set random betweem 5 to 50 seconds
  
  #Posted Time
  table_time <- ind_doc %>% html_text() %>% 
    str_extract_all("timeago.*") %>%
    str_extract_all("'.*PM") %>% 
    as.data.frame() %>% 
    as.tibble() %>% 
    set_names("PostedTime") %>% 
    separate(PostedTime, c("del", "PostedTime"), sep = "'") %>% 
    select("PostedTime")
  
  #Lat and Long
  table_lat_long <- ind_doc %>% 
    html_nodes("#map-canvas") %>% 
    str_extract_all("data-l.*") %>% 
    str_extract_all("\\d{2}\\.\\d*") %>% 
    as.data.frame() %>% t() %>% as.tibble() %>% 
    set_names("Lat", "Long")
  
  table_all_details <- ind_doc %>% 
    html_nodes("#fixedHeaderOnScroll .detail-title , .detail-title-main, h5, #price, .text-align-left .detail-title#fixedHeaderOnScroll .detail-title , .detail-title-main, h5, #price, .text-align-left .detail-title") %>% 
    html_text() %>% str_trim() %>% 
    as.tibble() %>%
    slice(6:51) %>% t() %>% as.tibble()
  
  final_table <- reduce(c(table_time, table_lat_long, table_all_details), cbind) %>% 
    as.tibble() %>% 
    mutate(id = propid) %>% 
    write_csv(path = "nobrokerdata203.csv", append = TRUE)
  }
  
}



all_ids <- read_csv("id202.csv") %>% slice(75:n()) #%>% rename("id" = "ff8081815b38ebc2015b3a2750b35955")



# Need final 2 steps and 1 split #SHould we use walk instead
all_ids %>% pull(id) %>% map_df(NB_ind_dump)

  #Problems
#326 #1493 #1760 #5662<- ignored
# 1256 - 1431 #repeated

library(multidplyr)
all_ids %>% head() %>% partition() %>% map_df(.$id, NB_ind_dump) %>% collect()


cleaned_table <- NB_dump %>% #read_csv("nobrokerdata.csv") %>% 
  select(-14, -16, -17, -18, -21, -22, -26, -28, -30, -32, -34, -36, -38, -40, -42, -43, -44, -46, -48) %>% 
  set_names("PostedTime", "Lat", "Long", "SaleType", "HouseType", "Address", "Verified", "LoanVerified", "Price", "Negotiable", "Area", "Measure", "MonthlyEMI", "Bedrooms", "Bathrooms", "FloorType", "Balconies", "ShortAddress", "Bldgtype", "Age", "OwnedBy", "Maintanance", "FloorType2", "Area2", "Furnished", "Facing", "FloorOn", "Parking", "PowerBackup", "WaterSupply", "propid")

# Further clearning should be made on analysis, data could be inconsistent as in there could be Floor or chawl or thousand, lakh or crore.
