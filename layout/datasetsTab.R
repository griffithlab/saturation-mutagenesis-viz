################################################################################
################ UI describing the layout for datasets #########################
################################################################################

datasetsTab <- function(){
  
  selection <- lapply(yamlInputs$assay_files, function(x){x$name})
  names(selection) <- selection
  
    tabPanel("Datasets",
             
             fluidPage(
               
               fluidRow(
                 
                 column(4,
                        
                        wellPanel(
                          
                          selectInput("assaySelect", label = h3("Dataset"), 
                                      choices = selection, 
                                      selected = selection[[1]])
                        )
                  ),
                 
                 column(8,
                        
                        h3("Information"),
                        htmlOutput("datasetsSource"),
                  )
                )
              )
    )
  
}