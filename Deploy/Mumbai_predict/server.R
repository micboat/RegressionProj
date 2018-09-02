

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  output$map_get_cordinates <- renderLeaflet({
    leaflet() %>% 
      addProviderTiles(providers$Wikimedia) %>% 
      addResetMapButton() %>%
      addSearchOSM() %>%
      fitBounds(lat1 = 19.25, lng1 = 72.86, lat2 = 18.899, lng2 = 72.87)
    
  })
  
  observeEvent(input$map_get_cordinates_click, {
    
    lat <- as.numeric(input$map_get_cordinates_click$lat)
    lng <- as.numeric(input$map_get_cordinates_click$lng)
    
    updateTextAreaInput(session, "address", value = revgeocode(c(lng, lat)))
    # Error if from outside Mumbai
  })
  
  observeEvent(input$submit, {
    #updateNumericInput(session, "Latitude", value = input$map_get_cordinates_click$lat)
    #updateNumericInput(session, "Longitude", value = input$map_get_cordinates_click$lng)
    latlon <- geocode(input$address) # Make clickable
    
    #This can be reduced to actual columns only.
    a_row_data <- tibble(
      Lat = latlon$lat,
      Long = latlon$lon,
      Negotiable = "Negotiable",
      Area = input$Area,
      NoofBedrooms = input$Bedrooms,
      NoofBathrooms = input$Bathrooms,
      FloorType = input$Floor_type,
      NoofBalconies = input$Balconies,
      Age = input$Age,
      Maint_sqft = input$Maint_sqft,
      Furnished = input$Furnished,
      Facing = input$Facing,
      OnFloor = input$OnFloor,
      NooffloorsinBldg = input$NoofFloorsinBldg,
      Parking = input$Parking,
      PowerBackup = input$PowerBackup,
      WaterSupply = input$Water_Supply
    )
    
    #print(as.data.frame(a_row_data))
    
    if(is.na(a_row_data$Lat)) {
      
      updateTextInput(session, "cordinates", value = "There was some error. Press Submit again after about 20 secs")
      
    } else {
      xgb_train <- readRDS("xgb_cv_model.rds")
      
      estimate_price <- xgb_train %>% predict(a_row_data)
      #print(estimate_price*1000)
      
      updateTextInput(session, "cordinates", value = estimate_price*1000)
    }
    
    # [object][object] in Area text
    
    
  })
  
  # output$cordinates <- renderText({
  #   print(input$map_get_cordinates_click$lat)
  #   print(input$map_get_cordinates_click$lng)
  # })
  # 
})

