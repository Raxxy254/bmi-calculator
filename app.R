############################################
# Data Professor                           #
# http://youtube.com/dataprofessor         #
# http://github.com/dataprofessor          #
# http://facebook.com/dataprofessor        #
# https://www.instagram.com/data.professor #
############################################

library(shiny)
library(shinythemes)


####################################
# User Interface                   #
####################################
ui <- fluidPage(
  theme = shinytheme("superhero"),
  
  navbarPage(
    title = "BMI CALCULATOR",
    collapsible = FALSE,inverse = F,position = "static-top",  # Ensures Render doesn't break the layout
    
    # This creates a "Three Dots" menu container on the navigation bar
    navbarMenu("\u2630", 
               
               tabPanel("Home",
                        sidebarPanel(
                          HTML("<h3>Input parameters</h3>"),
                          sliderInput("height", label = "Height (cm)", value = 175, min = 40, max = 250),
                          sliderInput("weight", label = "Weight (kg)", value = 70, min = 20, max = 100),
                          actionButton("submitbutton", "Submit", class = "btn btn-primary")
                        ),
                        mainPanel(
                          tags$label(h3('Results')),
                          verbatimTextOutput('contents'),
                          tableOutput('tabledata')
                        )
               ),
               
               tabPanel("About", 
                        titlePanel("About"),
                        div(includeMarkdown("about.qmd"), align="justify")
               )
               
    ) # End of navbarMenu
  ) # End of navbarPage
)


####################################
# Server                           #
####################################
server <- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({  
    
    bmi <- input$weight/( (input$height/100) * (input$height/100) )
    bmi <- data.frame(bmi)
    category <- ""
    if(bmi >= 30){
      category = "Obese"
    }else if(bmi >= 25){
      category = "Overweight"
    }else if(bmi >= 18.5){
      category = "Healthy"
    }else{
      category = "Underweight"
    }
    
    names(bmi) <- "BMI"
    bmi$"CATEGORY" <- category
    return(bmi)
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}


####################################
# Create Shiny App                 #
####################################
shinyApp(ui = ui, server = server)
