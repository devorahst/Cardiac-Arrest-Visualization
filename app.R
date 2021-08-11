library(shiny)
library(xtable)

#Define the UI for the app
ui <- fluidPage(
  
  #App Title
  titlePanel("CPR Report"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    sidebarPanel(
      
      #Use of order set?
      checkboxInput("orderSet", "Use of Order Set", value = FALSE, width = NULL),
      #PT/OT Consult
      checkboxInput("PT", "Completed PT/OT consult", value = FALSE, width = NULL),
      #EEG
      checkboxInput("EEG", "Completed EEG", value = FALSE, width = NULL),
      
      ##Normotension and Normothermia
      fileInput(
        "userCSV", 
        "Upload data",
        accept = ".csv"
      )

      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: CPR graph ----
      tableOutput("contents")
      
    )
  )
  
)

server <- function(input, output) {                  

    
    output$contents <- renderTable(
      {
        file <- input$userCSV
        ext <- tools::file_ext(file$datapath)
        
        req(file)
        validate(need(ext == "csv", "Please upload a csv file"))
        
        inputCSV <- read.csv(file$datapath, header = TRUE)
        
        #for each row
        #if hours are within parameters
        #edit bool acordingly
        Tension0 = FALSE
        Tension12 = FALSE
        Tension24 = FALSE
        Tension48 = FALSE
        Thermia0 = FALSE
        Thermia12 = FALSE
        Thermia24 = FALSE
        Thermia48 = FALSE
        
        tab <- matrix(
          c(                                                                         
            #orderset, normotension, normothermia, consult                                                                                                                                                                                                                                                                                                                                          
            input$orderSet,FALSE,FALSE,input$PT,  #0-12 hours                  
            input$orderSet,FALSE,FALSE,input$PT,  #12-24 hours                                                                          
            input$orderSet,FALSE,FALSE,input$PT,  #24-48 hour s
            input$orderSet,FALSE,FALSE,input$PT   #get PT/O            T consult from input
          ),                                                                           
          ncol=4,
          nrow=4
        )
        
        colnames(tab) <- c('0-12 hours','12-24 Hours','24-48 Hours','48-72 Hours')
        rownames(tab) <- c('Use of Order Set', 'Normotension', 'Normothermia (35-37 C)', 'PT/OT Consult')
        
        #convert matrix to table 
        
        M <- xtable(tab, align=rep("c", ncol(tab)+1))
      },
      rownames=TRUE
    )
    

    
    ## ADD GRAPH HERE
    
  }

shinyApp(ui = ui, server = server)