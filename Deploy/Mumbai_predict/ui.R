library(shiny); library(leaflet); library(default); library(shinydashboard); library(leaflet.extras); library(ggmap); library(shinycssloaders)

# Define UI for application that draws a histogram
shinyUI(navbarPage("Mumbai",
  theme = "style.css",
  
  tabPanel("Estiamte",
  fluidRow(
    column(width = 6,
           #On Modal please
           leafletOutput("map_get_cordinates", width = "200%") %>% withSpinner() %>% 
             box(),
           textAreaInput("address", "Approx address (or select it from above map)", placeholder = "Automatically filled by map", width = "130%"),
           "An approx address is fine!"
           ),
      
    
    column(
      width = 6,
      # Explain why these variables are important - this will help user
      #numericInput("Latitude", "Latitude", value = 500),
      #numericInput("Longitude", "Longitude", value = 500),
      
      
      column(width = 5, numericInput("Area", "Enter House Area in sq.ft", value = 500)),
      column(width = 5, numericInput("Bedrooms", "No of Bedrooms", value = 2)),
      column(width = 5, numericInput("Bathrooms", "No of Bathrooms", value = 2)),
      column(width = 5, numericInput("Balconies", "No of Balconies", value = 2)),
      column(width = 5, numericInput("Maint_sqft", "Maintaiance per sq ft", value = 3)),
      column(width = 5, numericInput("OnFloor", "On Floor", value = 3)),
      column(width = 5, numericInput("NoofFloorsinBldg", "Stories", value = 7)),

      
      column(width = 5, selectInput("Floor_type", "Floor Type", c("Marble/Granite", "Cement", "Vitrified Tiles", "Mosiac", "Wooden"))),
      column(width = 5, selectInput("Age", "Age of the bldg", c("Newly Constructed", "Under Construction", "1-3 years old", "3-5 years old", "5-10 years old", ">10 years old"))),
      column(width = 5, selectInput("Facing", "Facing", c("West", "East", "North", "South", "North-East", "North-West", "South-East", "South-West", "Don't know"))),
      column(width = 5, selectInput("Furnished", "Furnished", c("Full", "Semi", "Unfurnished"))),
      column(width = 5, selectInput("Parking", "Parking for", c("Bike", "Car", "Bike and Car", "None"))),
      
      #column(width = 5, checkboxInput("Furnised", "Is your house Furnished", value = FALSE)),
      column(width = 5, selectInput("PowerBackup", "Power Backup", c("Full", "None", "Partial"))),
      column(width = 5, selectInput("Water_Supply", "Borewell Water Supply", c("Borewell", "Corporation", "Both")))
      #column(width = 5, checkboxInput("Negotiable", "Negotiable", value = TRUE))
      ), #should we assume BMC
      
      actionButton("submit", "submit"),
      actionButton("Reset", "reset"),
      textInput("cordinates", "Price")
    )),
  
  tabPanel("About", "xgbosst Model"),
  
  tabPanel("Citeation", "This is prepared in R."),
  
  tabPanel("Contact Me", "I can be rechead at cv.vasim@gmail.com")
  
  #Github Icon
  
  
))
