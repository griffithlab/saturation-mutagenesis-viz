################################################################################
################ UI describing the layout for datasets #########################
################################################################################

datasetsTab <- function(){
  
    tabPanel("Datasets",
             
             fluidPage(
               
               fluidRow(
                 
                 column(4,
                        
                        wellPanel(
                          
                          selectInput("select", label = h3("Manuscript"), 
                                      choices = list("Kato et al. 2003" = 1, "giacomelli et al. 2018" = 2), 
                                      selected = 1)
                        )
                  ),
                 
                 column(8,
                        
                        h3("test")
                  )
                )
              )
    )
  
}